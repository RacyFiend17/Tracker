import UIKit

final class CreateTrackerTypeViewController: UIViewController {
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    var dateOfTrackerCreation = Date()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.text = "creation_of_tracker".localized
        return titleLabel
    } ()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("habit".localized, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        
        button.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("not_regular_event".localized, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        
        button.addTarget(self, action: #selector(irregularButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI( )
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubviews([titleLabel, habitButton, irregularButton])
        view.translatesAutoResizingMaskFalseTo(view.subviews)
        setupMainConstraints()
    }
    
    @objc private func setupMainConstraints () {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 114),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -112),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            habitButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 295),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            irregularButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            irregularButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            irregularButton.heightAnchor.constraint(equalTo: habitButton.heightAnchor),
        ])
    }
    
    @objc private func habitButtonTapped() {
        let vc = CreateTrackerViewController(trackerConfig: HabitConfig())
        vc.delegate = delegate
        vc.parentTypeControllerDelegate = self
        vc.dateOfTrackerCreation = dateOfTrackerCreation
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func irregularButtonTapped() {
        let vc = CreateTrackerViewController(trackerConfig: IrregularConfig())
        vc.delegate = delegate
        vc.parentTypeControllerDelegate = self
        vc.dateOfTrackerCreation = dateOfTrackerCreation
        self.present(vc, animated: true, completion: nil)
    }
}

extension CreateTrackerTypeViewController: CreateTrackerTypeDismissDelegate {
    func dismissCreateTrackerTypeViewController() {
        dismiss(animated: true)
    }
}
