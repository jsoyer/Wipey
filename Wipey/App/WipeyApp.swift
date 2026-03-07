import SwiftUI
import AppKit
import WipeyCore
import Combine

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
    @State private var timerCancellable: AnyCancellable?

    var body: some View {
        Group {
            if hasPermission {
                ContentView()
            } else {
                PermissionView()
            }
        }
        .onAppear {
            // Only start polling if we don't have permission yet
            if !hasPermission {
                startPermissionPolling()
            }
        }
    }
    
    private func startPermissionPolling() {
        // Poll every second until permission is granted
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                let currentPermission = AXIsProcessTrusted()
                if currentPermission && !hasPermission {
                    // Permission just granted - update state and cancel timer
                    hasPermission = true
                    timerCancellable?.cancel()
                    timerCancellable = nil
                } else if !hasPermission {
                    // Still waiting for permission
                    hasPermission = currentPermission
                }
            }
    }
}
