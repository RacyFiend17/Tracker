import Foundation

final class CreateCategoryViewModel {
    
    // MARK: Bindings
    var onButtonStateChanged: ((Bool) -> Void)?
    var onCategoryCreated: (() -> Void)?
    
    // MARK: Dependencies
    private let store: TrackerCategoryStoreProtocol
    
    // MARK: State
    private var categoryTitle: String = ""
    
    init(store: TrackerCategoryStoreProtocol) {
        self.store = store
    }
    
    // MARK: Method for loading data
    func createCategory() {
        let title = categoryTitle.trimmingCharacters(in: .whitespaces)
        guard !title.isEmpty else { return }
        
        store.addCategory(title: title)
        onCategoryCreated?()
    }
    
    // MARK: Methods for viewController
    func didChangeText(_ text: String?) {
        categoryTitle = text ?? ""
        let isValid = !categoryTitle.trimmingCharacters(in: .whitespaces).isEmpty
        onButtonStateChanged?(isValid)
    }
}
