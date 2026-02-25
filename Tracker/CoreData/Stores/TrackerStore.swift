import CoreData
import UIKit

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private var currentDate: Date = Date()
    private var searchQuery: String?
    private var currentTrackerFilter: TrackerFilter
    private let trackerRecordStore: TrackerRecordStoreProtocol
    private let fetchRequestController: NSFetchedResultsController<TrackerCategoryCoreData>
    var onChange: (() -> Void)?
    var onStatisticsChange: (() -> Void)?
    
    init(context: NSManagedObjectContext = ModelDataStack.shared.context, trackerRecordStore: TrackerRecordStoreProtocol) {
        self.context = context
        self.currentTrackerFilter = AppSettings.selectedFilter
        self.trackerRecordStore = trackerRecordStore
        
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
        guard let categories = fetchRequestController.fetchedObjects else {
            return 0
        }
        
        let filteredCategories = categories.filter { !filteredTrackers(for: $0, on: currentDate).isEmpty }

        return filteredCategories.count
    }
    
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
    
    func numberOfItems(in section: Int, on currentDate: Date) -> Int {
        guard let categories = fetchRequestController.fetchedObjects else {
            return 0
        }
        
        let filteredCategories = categories.filter { !filteredTrackers(for: $0, on: currentDate).isEmpty }
        
        let category = filteredCategories[section]
         
        return filteredTrackers(for: category, on: currentDate).count
    }
    
    func categoryTitle(at section: Int) -> String {
        guard let categories = fetchRequestController.fetchedObjects else {
            return ""
        }
        
        let filteredCategories = categories.filter { !filteredTrackers(for: $0, on: currentDate).isEmpty }
        return filteredCategories[section].title ?? ""
        
    }
    
    func categoryTitle(for tracker: Tracker) -> String {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        request.fetchLimit = 1
        
        do {
            guard let tracker = try context.fetch(request).first else {
                fatalError("Tracker with id \(tracker.id) not found")
            }
            
            guard let title = tracker.category?.title else {
                fatalError("Tracker has no category")
            }
            
            return title
            
        } catch {
            fatalError("Failed to fetch category title: \(error)")
        }
    }
    
    func tracker(at indexPath: IndexPath, on currentDate: Date) -> Tracker {
        guard let category = fetchRequestController.fetchedObjects?.filter({ !filteredTrackers(for: $0, on: currentDate).isEmpty})[indexPath.section] else {
            fatalError("Category not found")
        }
        
        let trackers = filteredTrackers(for: category, on: currentDate)
        let trackerCD = trackers[indexPath.item]
        
        guard
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
        
        AppSettings.areAnyTrackers = true
        
        ModelDataStack.shared.saveContext()
    }
    
    func updateTracker(_ tracker: Tracker, categoryTitle: String) {
        
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        request.fetchLimit = 1
        
        do {
            guard let trackerCD = try context.fetch(request).first else {
                assertionFailure("Tracker not found for update")
                return
            }
            
            let oldCategory = trackerCD.category
            
            trackerCD.name = tracker.name
            trackerCD.emoji = tracker.emoji
            trackerCD.color = tracker.color
            trackerCD.setSchedule(tracker.schedule)
            trackerCD.trackerTypeRaw = tracker.trackerType.rawValue
            trackerCD.dateCreated = tracker.dateCreated
            
            if oldCategory?.title != categoryTitle {
                let newCategory = fetchOrCreateCategory(title: categoryTitle)
                trackerCD.category = newCategory
            }
            
            checkForEmptyCategories(for: oldCategory)
            ModelDataStack.shared.saveContext()
            
            applyFilter()
            
        } catch {
            assertionFailure("Failed to update tracker: \(error)")
        }
    }
    
    func deleteTracker(_ id: UUID) {
        
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            if let tracker = try context.fetch(request).first {
                
                context.delete(tracker)
                let category = tracker.category
                
                checkForEmptyCategories(for: category)
                
                ModelDataStack.shared.saveContext()
            }
        } catch {
            assertionFailure("Failed to delete tracker: \(error)")
        }
        
        let recordRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        recordRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let records = try? context.fetch(recordRequest) else { return }
        for record in records {
            context.delete(record)
        }
        ModelDataStack.shared.saveContext()
    }
    
    func idealDays() -> Int {
        let recordRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        guard let records = try? context.fetch(recordRequest),
              !records.isEmpty else {
            return 0
        }
        
        // Группируем выполнения по датам
        var recordsByDate: [Date: [UUID]] = [:]
        
        for record in records {
            guard let date = record.date,
                  let id = record.id else { continue }
            
            recordsByDate[date, default: []].append(id)
        }
        
        var idealDaysCount = 0
        
        for (date, completedIDs) in recordsByDate {
            
            let weekday = Calendar.current.component(.weekday, from: date)
            
            let trackerRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            
            // Фильтр по дню недели
            trackerRequest.predicate = predicateForWeekday(weekday)
            
            guard let plannedTrackers = try? context.fetch(trackerRequest) else { continue }
            
            let plannedIDs = plannedTrackers.compactMap { $0.id }
            
            let completedSet = Set(completedIDs)
            let plannedSet = Set(plannedIDs)
            
            if !plannedSet.isEmpty && completedSet == plannedSet {
                idealDaysCount += 1
            }
        }
        
        return idealDaysCount
    }
    
    private func predicateForWeekday(_ weekday: Int) -> NSPredicate {
        switch weekday {
        case 1: return NSPredicate(format: "isSunday == YES")
        case 2: return NSPredicate(format: "isMonday == YES")
        case 3: return NSPredicate(format: "isTuesday == YES")
        case 4: return NSPredicate(format: "isWednesday == YES")
        case 5: return NSPredicate(format: "isThursday == YES")
        case 6: return NSPredicate(format: "isFriday == YES")
        case 7: return NSPredicate(format: "isSaturday == YES")
        default: return NSPredicate(value: false)
        }
    }
    
    func updateFilter(date: Date) {
        currentDate = date
        applyFilter()
    }
    
    func setFilter(_ filter: TrackerFilter) {
        currentTrackerFilter = filter
        
        if filter == .today {
            currentDate = Date().withoutTime
        }
        
        applyFilter()
    }
    
    func updateSearchQuery(_ query: String?) {
        searchQuery = query?.lowercased()
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

        var predicates: [NSPredicate] = []
        
        switch currentTrackerFilter {
        case .all:
            break
        case .today, .completed, .uncompleted:
            let weekdayPredicate = NSPredicate(format: "ANY trackers.%K == YES", weekdayKey)
            let datePredicate = NSPredicate(format: "ANY trackers.dateCreated <= %@", currentDate.withoutTime as NSDate)
            predicates = [weekdayPredicate, datePredicate]
        }

        if let query = searchQuery, !query.isEmpty {
            let searchPredicate = NSPredicate(format: "ANY trackers.name CONTAINS[c] %@", query)
            predicates.append(searchPredicate)
        }
        
        fetchRequestController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        try? fetchRequestController.performFetch()
        onChange?()
    }
    
    private func filteredTrackers(for category: TrackerCategoryCoreData, on currentDate: Date) -> [TrackerCoreData] {
        guard
            let trackers = category.trackers,
            let weekday = currentDate.weekday
        else { return [] }
        
        var filteredTrackers = trackers.compactMap { $0 as? TrackerCoreData }
        
        if let query = searchQuery, !query.isEmpty {
            filteredTrackers = filteredTrackers.filter {
                ($0.name?.lowercased().contains(query) ?? false)
            }
        }
        
        switch currentTrackerFilter {
        case .all:
            return filteredTrackers
        case .today:
            let weekdayKey = weekday.coreDataKey
            
            return filteredTrackers.filter { tracker in
                    tracker.value(forKey: weekdayKey) as? Bool == true
                    && (tracker.dateCreated ?? .distantPast) <= currentDate.withoutTime
                }
        case .completed:
            let weekdayKey = weekday.coreDataKey
            
            return filteredTrackers.filter { tracker in
                    tracker.value(forKey: weekdayKey) as? Bool == true
                    && (tracker.dateCreated ?? .distantPast) <= currentDate.withoutTime
                    && trackerRecordStore.isTrackerCompleted(tracker.id ?? UUID(), on: currentDate.withoutTime)
                }
        case .uncompleted:
            let weekdayKey = weekday.coreDataKey
            
            return filteredTrackers.filter { tracker in
                    tracker.value(forKey: weekdayKey) as? Bool == true
                    && (tracker.dateCreated ?? .distantPast) <= currentDate.withoutTime
                    && !trackerRecordStore.isTrackerCompleted(tracker.id ?? UUID(), on: currentDate.withoutTime)
                
                }
        }
    }
    
    private func checkForEmptyCategories(for category: TrackerCategoryCoreData?) {
        if let category,
           let trackers = category.trackers,
           trackers.count == 0 {
            context.delete(category)
        }
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        onStatisticsChange?()
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
