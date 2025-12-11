import Foundation

protocol AddTrackerConfig {
    var title: String { get }
    var isRegularTracker: Bool { get }
    var navigationCellTitles: [String] { get }
    var navigationCellSubtitles: [String] { get set }
}

struct HabitConfig: AddTrackerConfig {
    let title = "Новая привычка"
    let isRegularTracker = true
    let navigationCellTitles = ["Категория", "Расписание"]
    var navigationCellSubtitles: [String] = ["", ""]
}

struct IrregularConfig: AddTrackerConfig {
    let title = "Новое нерегулярное событие"
    let isRegularTracker = false
    let navigationCellTitles = ["Категория"]
    var navigationCellSubtitles: [String] = [""]
}
