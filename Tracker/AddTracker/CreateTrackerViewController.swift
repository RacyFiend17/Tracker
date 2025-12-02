import UIKit

final class CreateTrackerViewController: UIViewController {
    
    var type: TrackerType
    
    init(type: TrackerType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
    
protocol CreateTrackerViewControllerDelegate: AnyObject {
        func didCreateTracker(_ tracker: Tracker)
}
