import Foundation

enum AppSettings {
    private static let onboardingKey = "onboardingCompleted"
    
    static var isOnboardingCompleted: Bool {
        get { UserDefaults.standard.bool(forKey: onboardingKey) }
        set { UserDefaults.standard.set(newValue, forKey: onboardingKey) }
    }
}
