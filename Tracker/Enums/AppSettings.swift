import Foundation

enum AppSettings {
    
    private static let onboardingKey = "onboardingCompleted"
    private static let selectedFilterKey = "selectedTrackerFilter"
    private static let areAnyTrackersKey = "areAnyTrackers"
    
    static var areAnyTrackers: Bool {
        get { UserDefaults.standard.bool(forKey: areAnyTrackersKey) }
        set { UserDefaults.standard.set(newValue, forKey: areAnyTrackersKey) }
    }
    
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
