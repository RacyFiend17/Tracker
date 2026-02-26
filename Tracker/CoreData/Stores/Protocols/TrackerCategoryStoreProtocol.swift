import Foundation

protocol TrackerCategoryStoreProtocol {
    func fetchCategoriesNames() -> [String]
    func addCategory(title: String)
}
