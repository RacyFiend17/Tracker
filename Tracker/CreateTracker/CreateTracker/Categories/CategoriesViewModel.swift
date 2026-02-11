import UIKit

final class CategoriesViewModel {
    
    // MARK: Bindings
    var onCategoriesChanged: (() -> Void)?
    var onCategoryNameSelected: ((String) -> Void)?
    
    
    // MARK: Properties for viewController
    var numberOfRows: Int {
        categoriesNames.count
    }
    
    // MARK: - Dependencies
    private let store: TrackerCategoryStoreProtocol
    
    // MARK: - State
    private(set) var categoriesNames: [String] = []
    private(set) var selectedIndex: Int?
    
    init(store: TrackerCategoryStoreProtocol) {
        self.store = store
    }
    
    // MARK: Method for loading data
    func loadCategories() {
        categoriesNames = store.fetchCategoriesNames()
        onCategoriesChanged?()
    }
    
    // MARK: Methods for viewController
    func titleForCell(at indexPath: IndexPath) -> String {
        categoriesNames[indexPath.row]
    }
    
    func isSelected(at indexPath: IndexPath) -> Bool {
        selectedIndex == indexPath.row
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        let categoryName = categoriesNames[indexPath.row]
        
        onCategoriesChanged?()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.onCategoryNameSelected?(categoryName)
        }
    }
}
