import Foundation
import Observation

/// Central coordinator for a Wipey cleaning session.
/// Owns the state machine and orchestrates InputBlocker, ScreenDimmer, ExitWatcher.
///
/// SessionManager is platform-agnostic — it only depends on protocols.
/// Inject platform-specific implementations at the app entry point.
///
/// Thread safety: all public methods must be called from the main thread.
/// The countdown timer is explicitly scheduled on the main run loop.
@Observable
public final class SessionManager {

    // MARK: - Observable state

    public var state: SessionState = .idle
    public var secondsRemaining: Int = 0
    public var config: SessionConfig

    // MARK: - Dependencies

    private let inputBlocker: InputBlocker
    private let screenDimmer: ScreenDimmer
    private let exitWatcher: ExitWatcher

    // MARK: - Private

    private var countdownTimer: Timer?

    // MARK: - Init

    public init(
        inputBlocker: InputBlocker,
        screenDimmer: ScreenDimmer,
        config: SessionConfig = SessionConfig()
    ) {
        self.inputBlocker = inputBlocker
        self.screenDimmer = screenDimmer
        self.config = config

        self.exitWatcher = ExitWatcher()
        self.exitWatcher.onUnlock = { [weak self] in
            self?.endSession()
        }
    }

    deinit {
        // Guard against a session left active at teardown (e.g. process crash path).
        countdownTimer?.invalidate()
    }

    // MARK: - Session control

    public func startSession() throws {
        guard state == .idle else { return }
        guard config.hasValidExitMechanism else { return }

        state = .starting

        if config.blackoutScreen {
            screenDimmer.dim(animated: true)
        }

        inputBlocker.exitWatcher = exitWatcher

        do {
            try inputBlocker.startBlocking(config: config)
        } catch {
            // Rollback any side effects before re-throwing
            if screenDimmer.isDimmed {
                screenDimmer.restore(animated: false)
            }
            state = .idle
            throw error
        }

        exitWatcher.start(config: config)
        state = .active(startedAt: Date())
        startCountdown()
    }

    public func endSession() {
        // Strict guard: only accept the first endSession() call while active.
        // Using .isActive (not .ending) prevents a second call from re-running cleanup.
        guard state.isActive else { return }
        state = .ending

        countdownTimer?.invalidate()
        countdownTimer = nil

        inputBlocker.stopBlocking()
        exitWatcher.stop()

        if screenDimmer.isDimmed {
            screenDimmer.restore(animated: true)
        }

        secondsRemaining = 0
        state = .idle
    }

    // MARK: - Countdown

    private func startCountdown() {
        guard config.isEnabled(.autoTimer) else { return }
        secondsRemaining = Int(config.timerDuration)

        // Explicitly schedule on the main run loop so the callback is always
        // delivered on the main thread, regardless of which thread startSession() was called from.
        let timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.secondsRemaining -= 1
            if self.secondsRemaining <= 0 {
                self.endSession()
            }
        }
        RunLoop.main.add(timer, forMode: .common)
        countdownTimer = timer
    }
}
