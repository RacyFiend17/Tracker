import Foundation

protocol TrackerRecordStoreProtocol: AnyObject {
    func isTrackerCompleted(_ id: UUID, on date: Date) -> Bool
    func completedDaysCount(for id: UUID) -> Int
    func toggleTracker(_ id: UUID, on date: Date)
    func fetchAllRecords() -> [TrackerRecordCoreData]
    var onRecordsChanged: (() -> Void)? { get set }
    func bestPeriod() -> Int
    var completedTrackers: Int { get }
    func averageTasksPerDay() -> Int
}
