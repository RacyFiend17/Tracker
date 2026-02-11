import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = ModelDataStack.shared.context) {
        self.context = context
    }
}

extension TrackerCategoryStore: TrackerCategoryStoreProtocol {    
    func fetchCategoriesNames() -> [String] {
        let request = TrackerCategoryCoreData.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(
                key: "title",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare)
            )
        ]
        
        do {
            let objects = try context.fetch(request)
            
            return objects.compactMap { $0.title }
            
        } catch {
            print("Fetch categories error:", error)
            return []
        }
    }

    
    func addCategory(title: String) {
        let category = TrackerCategoryCoreData(context: context)
        category.title = title
        
        ModelDataStack.shared.saveContext()
    }
}

