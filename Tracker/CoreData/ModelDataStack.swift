import CoreData

final class ModelDataStack {
    static let shared = ModelDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerDataModel")
        container.loadPersistentStores{ description, error in
            if let error = error as NSError? {
                fatalError("Persistent store loading error: \(error)")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                fatalError("Unresolved Core Data save error: \(error)")
            }
        }
    }
}
