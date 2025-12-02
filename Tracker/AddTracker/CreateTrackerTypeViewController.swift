import UIKit

final class CreateTrackerTypeViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.text = "Создание трекера"
        return titleLabel
    } ()
    
    private let habitButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        
        button.addTarget(CreateTrackerTypeViewController.self, action: #selector(habitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let irregularButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        
        button.addTarget(CreateTrackerTypeViewController.self, action: #selector(irregularButtonTapped), for: .touchUpInside)
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
        let vc = CreateTrackerViewController(type: .habit)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func irregularButtonTapped() {
        let vc = CreateTrackerViewController(type: .irregular)
        self.present(vc, animated: true, completion: nil)
    }
}
