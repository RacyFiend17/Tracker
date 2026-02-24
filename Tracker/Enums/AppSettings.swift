import Foundation

enum AppSettings {
    
    private static let onboardingKey = "onboardingCompleted"
    private static let selectedFilterKey = "selectedTrackerFilter"
    
    static var isOnboardingCompleted: Bool {
        get { UserDefaults.standard.bool(forKey: onboardingKey) }
        set { UserDefaults.standard.set(newValue, forKey: onboardingKey) }
    }
    
    static var selectedFilter: TrackerFilter {
        get {
            guard
                let rawValue = UserDefaults.standard.string(forKey: selectedFilterKey),
                let filter = TrackerFilter(rawValue: rawValue)
            else {
                return .all
            }
            return filter
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: selectedFilterKey)
        }
    }
}
