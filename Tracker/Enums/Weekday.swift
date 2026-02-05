import Foundation

enum Weekday: Int, CaseIterable, Codable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var ruName: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
    
    var shortRuName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
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
