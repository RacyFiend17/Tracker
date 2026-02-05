import Foundation

protocol TrackerStoreProtocol: AnyObject {
    var onChange: (() -> Void)? { get set }

    func numberOfSections() -> Int
    func numberOfItems(in section: Int, on currentDate: Date) -> Int

    func categoryTitle(at section: Int) -> String
    func tracker(at indexPath: IndexPath, on currentDate: Date) -> Tracker

    func addTracker(_ tracker: Tracker, categoryTitle: String)
    
    func updateFilter(date: Date)
}
