import Testing
import XCTest
import SnapshotTesting

@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testViewControllerWithLightTheme() {
        let trackerStore = TrackerStore()
        let trackerRecordStore = TrackerRecordStore()
        let vc = TrackersViewController(trackerStore: trackerStore, trackerRecordStore: trackerRecordStore)
        
        vc.overrideUserInterfaceStyle = .light
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }

    
    func testViewControllerWithDarkTheme() {
        let trackerStore = TrackerStore()
        let trackerRecordStore = TrackerRecordStore()
        let vc = TrackersViewController(trackerStore: trackerStore, trackerRecordStore: trackerRecordStore)
        
        vc.overrideUserInterfaceStyle = .dark
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
}
