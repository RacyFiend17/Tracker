import CoreData

final class TrackerRecordStore: NSObject {

    // MARK: - Public callback
    var onRecordsChanged: (() -> Void)?

    // MARK: - Private
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!

    // MARK: - Init
    init(context: NSManagedObjectContext = ModelDataStack.shared.context) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    private func fetchRecord(_ id: UUID, date: Date) -> TrackerRecordCoreData? {
        let request = TrackerRecordCoreData.fetchRequest()
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %@", id as CVarArg),
            NSPredicate(format: "date == %@", date.withoutTime as NSDate)
        ])
        
        return try? context.fetch(request).first
    }
}

private extension TrackerRecordStore {
    
    func setupFetchedResultsController() {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        onRecordsChanged?()
    }
}

extension TrackerRecordStore: TrackerRecordStoreProtocol {
    
    func bestPeriod() -> Int {
        let request1: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        guard let trackers = try? context.fetch(request1) else {
            return 0
        }
            
            let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
            
            var maxCount = 0
            
            for tracker in trackers {
                guard let id = tracker.id else { continue }
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                let count = (try? context.count(for: request)) ?? 0
                maxCount = max(maxCount, count)
            }
            
            return maxCount
    }
    
    func completedTrackers() -> Int {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        return (try? context.count(for: request)) ?? 0
    }
    
    func averageTasksPerDay() -> Int {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        guard let records = try? context.fetch(request),
              !records.isEmpty else {
            return 0
        }
        
        let totalCount = records.count
        
        let uniqueDays = Set(records.compactMap { $0.date })
        
        let daysCount = uniqueDays.count
        
        guard daysCount > 0 else { return 0 }
        
        return Int((Double(totalCount) / Double(daysCount)).rounded())
    }
    

    
    func isTrackerCompleted(_ id: UUID, on date: Date) -> Bool {
        fetchRecord(id, date: date) != nil
    }
    
    func completedDaysCount(for id: UUID) -> Int {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let count = (try? context.fetch(request).count) ?? 0
        return count
    }
    
    func toggleTracker(_ id: UUID, on date: Date) {
        let today = Date().withoutTime
            
            guard date.withoutTime <= today else {
                return
            }
            
            if let record = fetchRecord(id, date: date) {
                context.delete(record)
            } else {
                let record = TrackerRecordCoreData(context: context)
                record.id = id
                record.date = date.withoutTime
            }
            
            ModelDataStack.shared.saveContext()
    }
    
    func fetchAllRecords() -> [TrackerRecordCoreData] {
            let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
            return (try? context.fetch(request)) ?? []
        }
}

