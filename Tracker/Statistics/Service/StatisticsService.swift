import CoreData

protocol StatisticsServiceProtocol {
    var bestPeriod: Int {get}
    var perfectDays: Int {get}
    var completedTrackers : Int {get}
    var averageTasksPerDay: Int {get}
    var onStatisticsChanged: (() -> Void)? {get set}
}

final class StatisticsService: StatisticsServiceProtocol {
    
    // MARK: Bindings
    var onStatisticsChanged: (() -> Void)?
    
    // MARK: Properties for viewController
    var bestPeriod: Int {
        trackerRecordStore.bestPeriod()
    }
    
    var perfectDays: Int {
        trackerStore.idealDays()
    }
    
    var completedTrackers: Int {
        trackerRecordStore.completedTrackers()
    }
    
    var averageTasksPerDay: Int {
        trackerRecordStore.averageTasksPerDay()
    }
    
    // MARK: - Dependencies
    
    let trackerStore: TrackerStoreProtocol
    let trackerRecordStore: TrackerRecordStoreProtocol
    
    static let shared = StatisticsService(trackerStore: TrackerStore(trackerRecordStore: TrackerRecordStore()), trackerRecordStore: TrackerRecordStore())
    
    private init(
        trackerStore: TrackerStoreProtocol,
        trackerRecordStore: TrackerRecordStoreProtocol
    ) {
        self.trackerStore = trackerStore
        self.trackerRecordStore = trackerRecordStore
        
        trackerRecordStore.onRecordsChanged = { [weak self] in
            self?.onStatisticsChanged?()
        }
    
        trackerStore.onStatisticsChange = { [weak self] in
            self?.onStatisticsChanged
        }
    }
}


