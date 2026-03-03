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

// MARK: - Tests

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

    func testInitialStateIsIdle() {
        XCTAssertEqual(session.state, .idle)
    }

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
    }

    func testEndSessionRestoresEverything() throws {
        try session.startSession()
        session.endSession()
        XCTAssertEqual(session.state, .idle)
        XCTAssertFalse(inputBlocker.isBlocking)
        XCTAssertFalse(screenDimmer.isDimmed)
    }

    func testCannotStartTwoSessions() throws {
        try session.startSession()
        try session.startSession()
        XCTAssertEqual(inputBlocker.startCallCount, 1)
    }

    func testPermissionDeniedThrows() {
        inputBlocker.shouldThrow = true
        XCTAssertThrowsError(try session.startSession())
        XCTAssertEqual(session.state, .idle)
        XCTAssertFalse(screenDimmer.isDimmed, "Screen must be restored when startBlocking throws")
    }

    func testNoBlackoutWhenDisabled() throws {
        session.config.blackoutScreen = false
        try session.startSession()
        XCTAssertFalse(screenDimmer.isDimmed)
    }
}
