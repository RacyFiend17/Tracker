import CoreData
import UIKit

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private var currentDate: Date = Date()
    private let fetchRequestController: NSFetchedResultsController<TrackerCategoryCoreData>
    var onChange: (() -> Void)?
    
    init(context: NSManagedObjectContext = ModelDataStack.shared.context) {
        self.context = context
        
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
        ]

        fetchRequestController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()

        fetchRequestController.delegate = self

        do {
            try fetchRequestController.performFetch()
        } catch {
            fatalError("Failed to fetch categories")
        }
    }
}


extension TrackerStore: TrackerStoreProtocol {
    
    func numberOfSections() -> Int {
        fetchRequestController.fetchedObjects?.count ?? 0
    }
    
    func numberOfItems(in section: Int) -> Int {
        let category = fetchRequestController.fetchedObjects?[section]
        return category?.trackers?.count ?? 0
    }
    
    func categoryTitle(at section: Int) -> String {
        fetchRequestController.fetchedObjects?[section].title ?? ""
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker {
        guard
            let category = fetchRequestController.fetchedObjects?[indexPath.section],
            let trackersOrderedSet = category.trackers,
            let trackerCD = trackersOrderedSet[indexPath.item] as? TrackerCoreData,
            let id = trackerCD.id,
            let name = trackerCD.name,
            let emoji = trackerCD.emoji,
            let dateCreated = trackerCD.dateCreated,
            let colorData = trackerCD.color,
            let color = colorData as? UIColor,
            let typeRaw = trackerCD.trackerTypeRaw,
            let trackerType = TrackerType(rawValue: typeRaw)
        else {
            fatalError("Failed to convert TrackerCoreData to Tracker")
        }
        
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: trackerCD.scheduleArray,
            trackerType: trackerType,
            dateCreated: dateCreated
        )
    }
    
    func addTracker(_ tracker: Tracker, categoryTitle: String) {
        let category = fetchOrCreateCategory(title: categoryTitle)
        
        let trackerCD = TrackerCoreData(context: context)
        trackerCD.id = tracker.id
        trackerCD.name = tracker.name
        trackerCD.emoji = tracker.emoji
        trackerCD.color = tracker.color
        trackerCD.setSchedule(tracker.schedule)
        trackerCD.trackerTypeRaw = tracker.trackerType.rawValue
        trackerCD.dateCreated = tracker.dateCreated
        trackerCD.category = category
        
        ModelDataStack.shared.saveContext()
    }
    
    func updateFilter(date: Date) {
        currentDate = date
        applyFilter()
    }
    
    private func fetchOrCreateCategory(title: String) -> TrackerCategoryCoreData {
            let request = TrackerCategoryCoreData.fetchRequest()
            request.predicate = NSPredicate(format: "title == %@", title)

        if let existing = try? context.fetch(request).first {
                return existing
            }

            let category = TrackerCategoryCoreData(context: context)
            category.title = title
            return category
        }
    
    private func applyFilter() {
        guard let weekday = currentDate.weekday else { return }

        let weekdayKey = weekday.coreDataKey

        let weekdayPredicate = NSPredicate(format: "ANY trackers.%K == YES", weekdayKey)
        let datePredicate = NSPredicate(format: "ANY trackers.dateCreated <= %@", currentDate.withoutTime as NSDate)

        fetchRequestController.fetchRequest.predicate =
            NSCompoundPredicate(andPredicateWithSubpredicates: [
                weekdayPredicate,
                datePredicate
            ])

        try? fetchRequestController.performFetch()
        onChange?()
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        onChange?()
    }
}

extension TrackerCoreData {

    var scheduleArray: [Weekday] {
        var result: [Weekday] = []

        if isMonday { result.append(.monday) }
        if isTuesday { result.append(.tuesday) }
        if isWednesday { result.append(.wednesday) }
        if isThursday { result.append(.thursday) }
        if isFriday { result.append(.friday) }
        if isSaturday { result.append(.saturday) }
        if isSunday { result.append(.sunday) }

        return result
    }
    
    func setSchedule(_ schedule: [Weekday]) {
            isMonday = schedule.contains(.monday)
            isTuesday = schedule.contains(.tuesday)
            isWednesday = schedule.contains(.wednesday)
            isThursday = schedule.contains(.thursday)
            isFriday = schedule.contains(.friday)
            isSaturday = schedule.contains(.saturday)
            isSunday = schedule.contains(.sunday)
        }
}
