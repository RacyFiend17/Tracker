import Testing
import XCTest
import SnapshotTesting

@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {
        let trackerStore = TrackerStore()
        let trackerRecordStore = TrackerRecordStore()
        let vc = TrackersViewController(trackerStore: trackerStore, trackerRecordStore: trackerRecordStore)
        
        assertSnapshot(matching: vc, as: .image)
    }

}
