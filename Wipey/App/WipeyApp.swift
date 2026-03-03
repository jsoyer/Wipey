import SwiftUI
import AppKit
import WipeyCore

@main
struct WipeyApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    // Sparkle is managed entirely by AppDelegate (single SPUStandardUpdaterController)

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

    @State private var hasPermission = AXIsProcessTrusted()

    // Polls every second while permission is missing, then stops automatically.
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
            guard !hasPermission else { return } // stop doing work once granted
            hasPermission = AXIsProcessTrusted()
        }
    }
}
