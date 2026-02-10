import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = ModelDataStack.shared.context) {
        self.context = context
    }
}
