import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarControllers()
        setupTabBar()
        
        view.backgroundColor = .white
    }
    
    private func setupTabBarControllers() {
        let statisticsViewController = StatisticsViewController()
        let trackerStore = TrackerStore()
        let trackerRecordStore = TrackerRecordStore()
        let trackersViewController = TrackersViewController(trackerStore: trackerStore, trackerRecordStore: trackerRecordStore)
        
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(resource: .trackersTabBarLogo), tag: 0)
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(resource: .statisticsTabBarLogo), tag: 1)
        
        viewControllers = [trackersViewController, statisticsViewController]
    }
    
    private func setupTabBar() {
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}

