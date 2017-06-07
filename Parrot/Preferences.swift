import Foundation

public struct Preferences {
    private init() {}
    public struct Controllers {
        private init() {}
    }
    
    public enum Key {
        public static let InterfaceStyle = "Parrot.InterfaceStyle"
        public static let SystemInterfaceStyle = "Parrot.SystemInterfaceStyle"
        public static let VibrancyStyle = "Parrot.VibrancyStyle"
        
        public static let AutoEmoji = "Parrot.AutoEmoji"
        public static let MessageTextSize = "Parrot.MessageTextSize"
        public static let Emoticons = "Parrot.Emoticons"
        public static let Completions = "Parrot.Completions"
        public static let MenuBarIcon = "Parrot.MenuBarIcon"
        
        public static let VibrateForceTouch = "Parrot.VibrateForceTouch"
        public static let VibrateInterval = "Parrot.VibrateInterval"
        public static let VibrateLength = "Parrot.VibrateLength"
    }
}

