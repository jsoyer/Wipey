import SwiftUI
import AppKit

/// Shown on first launch (or whenever Accessibility permission is not granted).
/// Guides the user through granting the required permission.
struct PermissionView: View {

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "keyboard.badge.ellipsis")
                .font(.system(size: 56))
                .foregroundStyle(.blue.gradient)
                .symbolRenderingMode(.multicolor)

            VStack(spacing: 8) {
                Text("permission.title", comment: "Title of the permission onboarding screen")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("permission.body", comment: "Explanation of why Accessibility permission is needed")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            VStack(spacing: 12) {
                Button {
                    openAccessibilitySettings()
                } label: {
                    Text("permission.cta", comment: "Button to open System Settings for Accessibility permission")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Text("permission.instructions", comment: "Step-by-step instructions after opening System Settings")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
        .frame(width: 380, height: 480)
    }

    private func openAccessibilitySettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }
}
