import Testing
import XCTest
import SnapshotTesting

@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testViewControllerWithLightTheme() {
        let trackerRecordStore = TrackerRecordStore()
        let trackerStore = TrackerStore(trackerRecordStore: trackerRecordStore)
        let vc = TrackersViewController(trackerStore: trackerStore, trackerRecordStore: trackerRecordStore)

        vc.overrideUserInterfaceStyle = .light
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testViewControllerWithDarkTheme() {
        let trackerRecordStore = TrackerRecordStore()
        let trackerStore = TrackerStore(trackerRecordStore: trackerRecordStore)
        let vc = TrackersViewController(trackerStore: trackerStore, trackerRecordStore: trackerRecordStore)

        vc.overrideUserInterfaceStyle = .dark
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
