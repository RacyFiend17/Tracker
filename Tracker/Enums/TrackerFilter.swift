enum TrackerFilter: String, CaseIterable {
    case all = "all_trackers"
    case today = "trackers_for_today"
    case completed = "done_trackers"
    case uncompleted = "not_done_trackers"
}

extension TrackerFilter {
    static var localizedTitles: [String] {
        allCases.map { $0.rawValue.localized }
    }
}
