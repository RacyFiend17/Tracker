import Foundation

enum Weekday: Int, CaseIterable, Codable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var localizedName: String {
        switch self {
        case .monday: return NSLocalizedString("weekday_monday", comment: "")
        case .tuesday: return NSLocalizedString("weekday_tuesday", comment: "")
        case .wednesday: return NSLocalizedString("weekday_wednesday", comment: "")
        case .thursday: return NSLocalizedString("weekday_thursday", comment: "")
        case .friday: return NSLocalizedString("weekday_friday", comment: "")
        case .saturday: return NSLocalizedString("weekday_saturday", comment: "")
        case .sunday: return NSLocalizedString("weekday_sunday", comment: "")
        }
    }
    
    var localizedShortName: String {
        switch self {
        case .monday: return NSLocalizedString("weekday_short_monday", comment: "")
        case .tuesday: return NSLocalizedString("weekday_short_tuesday", comment: "")
        case .wednesday: return NSLocalizedString("weekday_short_wednesday", comment: "")
        case .thursday: return NSLocalizedString("weekday_short_thursday", comment: "")
        case .friday: return NSLocalizedString("weekday_short_friday", comment: "")
        case .saturday: return NSLocalizedString("weekday_short_saturday", comment: "")
        case .sunday: return NSLocalizedString("weekday_short_sunday", comment: "")
        }
    }
    
    var coreDataKey: String {
        switch self {
        case .monday: return "isMonday"
        case .tuesday: return "isTuesday"
        case .wednesday: return "isWednesday"
        case .thursday: return "isThursday"
        case .friday: return "isFriday"
        case .saturday: return "isSaturday"
        case .sunday: return "isSunday"
        }
    }
}
