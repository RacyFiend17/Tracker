import Foundation

protocol TrackerStoreProtocol: AnyObject {
    var onChange: (() -> Void)? { get set }
    var onStatisticsChange: (() -> Void)? { get set }

    func numberOfSections() -> Int
    func numberOfItems(in section: Int, on currentDate: Date) -> Int

    func categoryTitle(at section: Int) -> String
    func categoryTitle(for tracker: Tracker) -> String
    func tracker(at indexPath: IndexPath, on currentDate: Date) -> Tracker

    func addTracker(_ tracker: Tracker, categoryTitle: String)
    func updateTracker(_ tracker: Tracker, categoryTitle: String)
    func deleteTracker(_ id: UUID)
    
    func idealDays() -> Int
    
    func updateFilter(date: Date)
    func setFilter(_ filter: TrackerFilter)
    func updateSearchQuery(_ query: String?)
}
