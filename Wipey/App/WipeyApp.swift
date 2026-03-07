import SwiftUI
import AppKit
import WipeyCore

@main
struct WipeyApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
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
