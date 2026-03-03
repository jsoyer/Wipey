import Foundation

/// Sarcastic (and zen) remarks displayed during a cleaning session.
public enum Remarks {

    public static func idle(style: PreferencesManager.RemarksStyle) -> String {
        switch style {
        case .sarcastic: return sarcasticIdle.randomElement()!
        case .zen:       return zenIdle.randomElement()!
        case .silent:    return ""
        }
    }

    public static func active(style: PreferencesManager.RemarksStyle) -> String {
        switch style {
        case .sarcastic: return sarcasticActive.randomElement()!
        case .zen:       return zenActive.randomElement()!
        case .silent:    return ""
        }
    }

    public static func done(style: PreferencesManager.RemarksStyle) -> String {
        switch style {
        case .sarcastic: return sarcasticDone.randomElement()!
        case .zen:       return zenDone.randomElement()!
        case .silent:    return ""
        }
    }

    // MARK: - Sarcastic

    private static let sarcasticIdle = [
        "Ready to get squeaky clean.",
        "Your keyboard is judging you.",
        "Fingerprints? We don't do fingerprints here.",
        "Look at this mess. We need to talk.",
        "One wipe at a time.",
    ]

    private static let sarcasticActive = [
        "Wiping away the evidence...",
        "Your keyboard needed this. Trust me.",
        "Please don't sneeze on me.",
        "Fingerprints? What fingerprints?",
        "This is weirdly satisfying.",
        "Almost as clean as your conscience.",
        "You really let it get that bad?",
        "I've seen worse. Actually, no I haven't.",
    ]

    private static let sarcasticDone = [
        "Much cleaner. You're welcome.",
        "Squeaky clean. Obviously.",
        "Go ahead and touch it again. I dare you.",
        "My work here is done.",
        "You may now resume typing gibberish.",
    ]

    // MARK: - Zen

    private static let zenIdle = [
        "Ready when you are.",
        "A clean device is a clear mind.",
        "Take a moment for your Mac.",
    ]

    private static let zenActive = [
        "Cleaning in progress...",
        "Taking good care of your device.",
        "Almost done.",
        "Breathe.",
    ]

    private static let zenDone = [
        "All clean.",
        "Well done.",
        "Your device thanks you.",
    ]
}
