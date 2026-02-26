import Foundation

protocol AddTrackerConfig {
    var title: String { get }
    var isRegularTracker: Bool { get }
    var navigationCellTitles: [String] { get }
    var navigationCellSubtitles: [String] { get set }
}

struct HabitConfig: AddTrackerConfig {
    let title = "new_habit".localized
    let isRegularTracker = true
    let navigationCellTitles = ["category".localized, "schedule".localized]
    var navigationCellSubtitles: [String] = ["", ""]
}

struct IrregularConfig: AddTrackerConfig {
    let title = "new_not_regular_event".localized
    let isRegularTracker = false
    let navigationCellTitles = ["category".localized]
    var navigationCellSubtitles: [String] = [""]
}
