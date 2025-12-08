import UIKit

final class CreateTrackerViewController: UIViewController {
    
    private var trackerConfig: AddTrackerConfig
    private var chosenDays: [Weekday] = []
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.text = trackerConfig.title
        
        return titleLabel
    } ()
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView.register(NavigationCell.self, forCellReuseIdentifier: NavigationCell.reuseIdentifier)
        tableView.isScrollEnabled = false
        
        return tableView
    } ()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor(resource: .ypRed).cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor(resource: .ypRed), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        return button
    } ()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.backgroundColor = UIColor(resource: .ypGray)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(createButtonDidTap), for: .touchUpInside)
        return button
    } ()
    
    init(trackerConfig: AddTrackerConfig) {
        self.trackerConfig = trackerConfig
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubviews([titleLabel, tableView, createButton, cancelButton])
        view.translatesAutoResizingMaskFalseTo(view.subviews)
        
        setupConstraints()
        
    }
    
    @objc private func setupConstraints () {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor),
            
            createButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
        ])
    }
    
    @objc private func cancelButtonDidTap() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonDidTap() {
        
    }
}


protocol CreateTrackerViewControllerDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker)
}

extension CreateTrackerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if trackerConfig.isRegularTracker {
                return 2
            }
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TextFieldCell.reuseIdentifier,
                for: indexPath
            ) as? TextFieldCell else {
                print("Failed to dequeue TextFieldCell")
                return UITableViewCell()
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NavigationCell.reuseIdentifier,
                for: indexPath
            ) as? NavigationCell else {
                print("Failed to dequeue NavigationCell")
                return UITableViewCell()
            }
            
            let titles = trackerConfig.navigationCellTitles
            let subtitles = trackerConfig.navigationCellSubtitles
            let title = titles[indexPath.row]
            let subtitle = indexPath.row < subtitles.count ? subtitles[indexPath.row] : nil
            
            let isLast = indexPath.row == titles.count - 1
            let isFirst = indexPath.row == 0

            var cornerStyle: UIRectCorner? = nil
            if titles.count == 1 {
                cornerStyle = [.allCorners]
            } else if isFirst {
                cornerStyle = [.topLeft, .topRight]
            } else if isLast {
                cornerStyle = [.bottomLeft, .bottomRight]
            }
            
            let showSeparator = !isLast
            
            cell.configure(title: title,
                           subtitle: subtitle,
                           showSeparator: showSeparator,
                           roundedCorners: cornerStyle)
            
            return cell

        default:
            return UITableViewCell()
        }
    }
}

extension CreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 1 {
            let vc = ScheduleViewController()
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
}

extension CreateTrackerViewController: ScheduleViewControllerDelegate {
    func didSelectDays(_ days: Set<Weekday>) {
        if !days.isEmpty {
            
            
            var daysString = ""
            
            switch days.count {
                case 7:
                daysString = "Каждый день"
                default :
                let sortedDays = days.sorted { $0.rawValue < $1.rawValue }
                chosenDays = sortedDays
                daysString = sortedDays.map { $0.shortRuName }.joined(separator: ", ")
            }
            
            trackerConfig.navigationCellSubtitles[1] = daysString
            
            let indexPath = IndexPath(row: 1, section: 1)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}


