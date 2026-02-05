import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = ModelDataStack.shared.context) {
        self.context = context
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


extension TrackerRecordStore: TrackerRecordStoreProtocol {
    
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
}
