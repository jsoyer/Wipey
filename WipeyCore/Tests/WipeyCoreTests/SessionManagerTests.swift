import XCTest
@testable import WipeyCore

// MARK: - Mocks

final class MockInputBlocker: InputBlocker {
    private(set) var isBlocking = false
    private(set) var startCallCount = 0
    private(set) var stopCallCount = 0
    var shouldThrow = false
    var exitWatcher: ExitWatcher?

    func startBlocking(config: SessionConfig) throws {
        if shouldThrow { throw InputBlockerError.accessibilityPermissionDenied }
        isBlocking = true
        startCallCount += 1
    }

    func stopBlocking() {
        isBlocking = false
        stopCallCount += 1
    }
}

final class MockScreenDimmer: ScreenDimmer {
    private(set) var isDimmed = false
    private(set) var dimCallCount = 0
    private(set) var restoreCallCount = 0

    func dim(animated: Bool) {
        isDimmed = true
        dimCallCount += 1
    }

    func restore(animated: Bool) {
        isDimmed = false
        restoreCallCount += 1
    }
}

// MARK: - SessionManager tests

final class SessionManagerTests: XCTestCase {

    var inputBlocker: MockInputBlocker!
    var screenDimmer: MockScreenDimmer!
    var session: SessionManager!

    override func setUp() {
        inputBlocker = MockInputBlocker()
        screenDimmer = MockScreenDimmer()
        session = SessionManager(
            inputBlocker: inputBlocker,
            screenDimmer: screenDimmer,
            config: SessionConfig(
                lockKeyboard: true,
                lockTrackpad: true,
                blackoutScreen: true,
                timerDuration: 300
            )
        )
    }

    // MARK: - Initial state

    func testInitialStateIsIdle() {
        XCTAssertEqual(session.state, .idle)
        XCTAssertEqual(session.secondsRemaining, 0)
    }

    // MARK: - Session start

    func testStartSessionTransitionsToActive() throws {
        try session.startSession()
        XCTAssertTrue(session.state.isActive)
    }

    func testStartSessionCallsInputBlocker() throws {
        try session.startSession()
        XCTAssertTrue(inputBlocker.isBlocking)
        XCTAssertEqual(inputBlocker.startCallCount, 1)
    }

    func testStartSessionDimsScreen() throws {
        try session.startSession()
        XCTAssertTrue(screenDimmer.isDimmed)
        XCTAssertEqual(screenDimmer.dimCallCount, 1)
    }

    func testStartSessionRecordsStartDate() throws {
        let before = Date()
        try session.startSession()
        let after = Date()
        let startDate = session.state.startDate
        XCTAssertNotNil(startDate)
        XCTAssertGreaterThanOrEqual(startDate!, before)
        XCTAssertLessThanOrEqual(startDate!, after)
    }

    func testCannotStartTwoSessions() throws {
        try session.startSession()
        try session.startSession()
        XCTAssertEqual(inputBlocker.startCallCount, 1,
                       "startBlocking must only be called once even if startSession is called twice")
    }

    // MARK: - Session end

    func testEndSessionRestoresEverything() throws {
        try session.startSession()
        session.endSession()
        XCTAssertEqual(session.state, .idle)
        XCTAssertFalse(inputBlocker.isBlocking)
        XCTAssertFalse(screenDimmer.isDimmed)
        XCTAssertEqual(session.secondsRemaining, 0)
    }

    func testEndSessionIsIdempotent() throws {
        try session.startSession()
        session.endSession()
        session.endSession()
        // stopBlocking should only be called once — the second endSession is a no-op
        XCTAssertEqual(inputBlocker.stopCallCount, 1,
                       "stopBlocking must not be called again on a second endSession")
    }

    func testEndSessionWhileIdleIsNoOp() {
        session.endSession()
        XCTAssertEqual(session.state, .idle)
        XCTAssertEqual(inputBlocker.stopCallCount, 0)
    }

    // MARK: - Error handling

    func testPermissionDeniedThrows() {
        inputBlocker.shouldThrow = true
        XCTAssertThrowsError(try session.startSession()) { error in
            XCTAssertEqual(error as? InputBlockerError, .accessibilityPermissionDenied)
        }
        XCTAssertEqual(session.state, .idle,
                       "State must be rolled back to .idle when startBlocking throws")
        XCTAssertFalse(screenDimmer.isDimmed,
                       "Screen must be restored when startBlocking throws")
    }

    func testNoValidExitMechanismPreventsStart() throws {
        session.config.enabledExitMechanisms = []
        try session.startSession() // should silently return without throwing
        XCTAssertEqual(session.state, .idle,
                       "Session must not start when there is no valid exit mechanism")
        XCTAssertEqual(inputBlocker.startCallCount, 0)
    }

    // MARK: - Screen blackout

    func testNoBlackoutWhenDisabled() throws {
        session.config.blackoutScreen = false
        try session.startSession()
        XCTAssertFalse(screenDimmer.isDimmed)
        XCTAssertEqual(screenDimmer.dimCallCount, 0)
    }

    func testScreenRestoredOnEnd() throws {
        try session.startSession()
        session.endSession()
        XCTAssertEqual(screenDimmer.restoreCallCount, 1)
    }

    // MARK: - Countdown timer

    func testSecondsRemainingInitializedOnStart() throws {
        session.config.enabledExitMechanisms.insert(.autoTimer)
        session.config.timerDuration = 42
        try session.startSession()
        XCTAssertEqual(session.secondsRemaining, 42)
    }

    func testSecondsRemainingIsZeroWhenTimerDisabled() throws {
        session.config.enabledExitMechanisms = [.holdKey]
        try session.startSession()
        XCTAssertEqual(session.secondsRemaining, 0,
                       "secondsRemaining must stay 0 when autoTimer is disabled")
    }

    func testCountdownEndsSession() throws {
        session.config.enabledExitMechanisms = [.autoTimer]
        session.config.timerDuration = 1

        try session.startSession()
        XCTAssertTrue(session.state.isActive)

        // Spin the main RunLoop until the session self-terminates or we time out.
        // Using RunLoop directly avoids the GCD/main-queue scheduling race that
        // DispatchQueue.main.asyncAfter can introduce when the timer fires on the
        // same main RunLoop iteration.
        let deadline = Date(timeIntervalSinceNow: 3)
        while session.state.isActive && Date() < deadline {
            RunLoop.main.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
        }

        XCTAssertEqual(session.state, .idle, "Session must auto-end after timer expires")
    }
}
