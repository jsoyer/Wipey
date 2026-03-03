import SwiftUI
import AppKit
import WipeyCore

@main
struct WipeyApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appDelegate.sessionManager)
        }
        .defaultSize(width: 380, height: 480)
        .windowResizability(.contentSize)

        Settings {
            SettingsView()
                .environment(appDelegate.sessionManager)
        }
    }
}

// MARK: - Root view (permission gate)

private struct RootView: View {

    @Environment(SessionManager.self) private var session
    @State private var hasPermission = AXIsProcessTrusted()

    private let permissionTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Group {
            if hasPermission {
                ContentView()
            } else {
                PermissionView()
            }
        }
        .onReceive(permissionTimer) { _ in
            if !hasPermission {
                hasPermission = AXIsProcessTrusted()
            }
        }
    }
}
