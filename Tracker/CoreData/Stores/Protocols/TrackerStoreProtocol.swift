import Foundation

protocol TrackerStoreProtocol: AnyObject {
    var onChange: (() -> Void)? { get set }

    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int

    func categoryTitle(at section: Int) -> String
    func tracker(at indexPath: IndexPath) -> Tracker

    func addTracker(_ tracker: Tracker, categoryTitle: String)
    
    func updateFilter(date: Date)
}
