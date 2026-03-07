import Foundation

/// Sarcastic (and zen) remarks displayed during a cleaning session.
public enum Remarks {

    public static func idle(style: PreferencesManager.RemarksStyle) -> String {
        switch style {
        case .sarcastic: return sarcasticIdle.randomElement() ?? ""
        case .zen:       return zenIdle.randomElement() ?? ""
        case .silent:    return ""
        }
    }

    public static func active(style: PreferencesManager.RemarksStyle) -> String {
        switch style {
        case .sarcastic: return sarcasticActive.randomElement() ?? ""
        case .zen:       return zenActive.randomElement() ?? ""
        case .silent:    return ""
        }
    }

    public static func done(style: PreferencesManager.RemarksStyle) -> String {
        switch style {
        case .sarcastic: return sarcasticDone.randomElement() ?? ""
        case .zen:       return zenDone.randomElement() ?? ""
        case .silent:    return ""
        }
    }

    // MARK: - Sarcastic

    private static let sarcasticIdle = [
        String(localized: "remark.sarcastic.idle.1", defaultValue: "Ready to get squeaky clean.", comment: "Sarcastic idle remark"),
        String(localized: "remark.sarcastic.idle.2", defaultValue: "Your keyboard is judging you.", comment: "Sarcastic idle remark"),
        String(localized: "remark.sarcastic.idle.3", defaultValue: "Fingerprints? We don't do fingerprints here.", comment: "Sarcastic idle remark"),
        String(localized: "remark.sarcastic.idle.4", defaultValue: "Look at this mess. We need to talk.", comment: "Sarcastic idle remark"),
        String(localized: "remark.sarcastic.idle.5", defaultValue: "One wipe at a time.", comment: "Sarcastic idle remark"),
    ]

    private static let sarcasticActive = [
        String(localized: "remark.sarcastic.active.1", defaultValue: "Wiping away the evidence...", comment: "Sarcastic active remark"),
        String(localized: "remark.sarcastic.active.2", defaultValue: "Your keyboard needed this. Trust me.", comment: "Sarcastic active remark"),
        String(localized: "remark.sarcastic.active.3", defaultValue: "Please don't sneeze on me.", comment: "Sarcastic active remark"),
        String(localized: "remark.sarcastic.active.4", defaultValue: "Fingerprints? What fingerprints?", comment: "Sarcastic active remark"),
        String(localized: "remark.sarcastic.active.5", defaultValue: "This is weirdly satisfying.", comment: "Sarcastic active remark"),
        String(localized: "remark.sarcastic.active.6", defaultValue: "Almost as clean as your conscience.", comment: "Sarcastic active remark"),
        String(localized: "remark.sarcastic.active.7", defaultValue: "You really let it get that bad?", comment: "Sarcastic active remark"),
        String(localized: "remark.sarcastic.active.8", defaultValue: "I've seen worse. Actually, no I haven't.", comment: "Sarcastic active remark"),
    ]

    private static let sarcasticDone = [
        String(localized: "remark.sarcastic.done.1", defaultValue: "Much cleaner. You're welcome.", comment: "Sarcastic done remark"),
        String(localized: "remark.sarcastic.done.2", defaultValue: "Squeaky clean. Obviously.", comment: "Sarcastic done remark"),
        String(localized: "remark.sarcastic.done.3", defaultValue: "Go ahead and touch it again. I dare you.", comment: "Sarcastic done remark"),
        String(localized: "remark.sarcastic.done.4", defaultValue: "My work here is done.", comment: "Sarcastic done remark"),
        String(localized: "remark.sarcastic.done.5", defaultValue: "You may now resume typing gibberish.", comment: "Sarcastic done remark"),
    ]

    // MARK: - Zen

    private static let zenIdle = [
        String(localized: "remark.zen.idle.1", defaultValue: "Ready when you are.", comment: "Zen idle remark"),
        String(localized: "remark.zen.idle.2", defaultValue: "A clean device is a clear mind.", comment: "Zen idle remark"),
        String(localized: "remark.zen.idle.3", defaultValue: "Take a moment for your Mac.", comment: "Zen idle remark"),
    ]

    private static let zenActive = [
        String(localized: "remark.zen.active.1", defaultValue: "Cleaning in progress...", comment: "Zen active remark"),
        String(localized: "remark.zen.active.2", defaultValue: "Taking good care of your device.", comment: "Zen active remark"),
        String(localized: "remark.zen.active.3", defaultValue: "Almost done.", comment: "Zen active remark"),
        String(localized: "remark.zen.active.4", defaultValue: "Breathe.", comment: "Zen active remark"),
    ]

    private static let zenDone = [
        String(localized: "remark.zen.done.1", defaultValue: "All clean.", comment: "Zen done remark"),
        String(localized: "remark.zen.done.2", defaultValue: "Well done.", comment: "Zen done remark"),
        String(localized: "remark.zen.done.3", defaultValue: "Your device thanks you.", comment: "Zen done remark"),
    ]
}
