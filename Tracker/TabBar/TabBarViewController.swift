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
        let trackerRecordStore = TrackerRecordStore()
        let trackerStore = TrackerStore(trackerRecordStore: trackerRecordStore)
        let trackersViewController = TrackersViewController(trackerStore: trackerStore, trackerRecordStore: trackerRecordStore)
        
        trackersViewController.tabBarItem = UITabBarItem(title: "trackers".localized, image: UIImage(resource: .trackersTabBarLogo), tag: 0)
        statisticsViewController.tabBarItem = UITabBarItem(title: "statistics".localized, image: UIImage(resource: .statisticsTabBarLogo), tag: 1)
        
        viewControllers = [trackersViewController, statisticsViewController]
    }
    
    private func setupTabBar() {
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(resource: .ypWhite)
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}

