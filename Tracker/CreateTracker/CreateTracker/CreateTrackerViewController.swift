import UIKit

// MARK: - Protocols

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, with categoryName: String)
}

protocol CreateTrackerTypeDismissDelegate: AnyObject {
    func dismissCreateTrackerTypeViewController()
}

// MARK: - CreateTrackerViewController

final class CreateTrackerViewController: UIViewController {
    
    // MARK: - Delegates

    weak var delegate: CreateTrackerViewControllerDelegate?
    weak var parentTypeControllerDelegate: CreateTrackerTypeDismissDelegate?
    
    // MARK: - Properties
    
    private var trackerConfig: AddTrackerConfig
    private var chosenTrackerSchedule: [Weekday] = []
    private var chosenTrackerName: String = ""
    private var chosenCategoryName: String = "Че-то там"
    private var chosenTrackerEmoji: String = ""
    private var chosenTrackerColor: UIColor = .white
    var dateOfTrackerCreation = Date()
    
    // MARK: - UI Components
    
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
        tableView.register(CollectionOfEmojiCell.self, forCellReuseIdentifier: CollectionOfEmojiCell.reuseIdentifier)
        tableView.register(EmojiHeaderCell.self, forCellReuseIdentifier: EmojiHeaderCell.reuseIdentifier)
        tableView.register(CollectionOfColorsCell.self, forCellReuseIdentifier: CollectionOfColorsCell.reuseIdentifier)
        tableView.register(ColorHeaderCell.self, forCellReuseIdentifier: ColorHeaderCell.reuseIdentifier)
        
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
        button.isEnabled = false
        button.addTarget(self, action: #selector(createButtonDidTap), for: .touchUpInside)
        return button
    } ()
    
    // MARK: - Initializer
    
    init(trackerConfig: AddTrackerConfig) {
        self.trackerConfig = trackerConfig
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTableViewDelegateAndDataSource()
        setupUI()
        setupGestureRecognizers()
    }
    
    // MARK: - Setup Methods
    
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
    
    // MARK: - Actions
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func cancelButtonDidTap() {
        dismiss(animated: true)
        chosenTrackerSchedule = []
        chosenTrackerName = ""
        chosenCategoryName = ""
        chosenTrackerEmoji = ""
        chosenTrackerColor = .white
    }
    
    @objc private func createButtonDidTap() {
        if chosenTrackerName.isEmpty || chosenCategoryName.isEmpty || chosenTrackerEmoji.isEmpty || chosenTrackerColor == .white { return }
        else {
            if trackerConfig.isRegularTracker {
                if chosenTrackerSchedule.isEmpty { return }
                let newTracker = Tracker(
                    id: UUID(),
                    name: chosenTrackerName,
                    color: chosenTrackerColor,
                    emoji: chosenTrackerEmoji,
                    schedule: chosenTrackerSchedule,
                    trackerType: TrackerType.habit,
                    dateCreated: dateOfTrackerCreation
                    )
                dismiss(animated: true)
                parentTypeControllerDelegate?.dismissCreateTrackerTypeViewController()
                delegate?.didCreateTracker(newTracker, with: chosenCategoryName)
            } else {
                let newTracker = Tracker(
                    id: UUID(),
                    name: chosenTrackerName,
                    color: chosenTrackerColor,
                    emoji: chosenTrackerEmoji,
                    schedule: Weekday.allCases,
                    trackerType: TrackerType.habit,
                    dateCreated: dateOfTrackerCreation
                    )
                
                dismiss(animated: true)
                parentTypeControllerDelegate?.dismissCreateTrackerTypeViewController()
                delegate?.didCreateTracker(newTracker, with: chosenCategoryName)
            
            }
        }
    }
    
    // MARK: - Helpers
    
    private func setupTableViewDelegateAndDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupGestureRecognizers(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func isReadyToCreateTracker(for trackerConfig: AddTrackerConfig) -> Bool {
        if trackerConfig.isRegularTracker{
            return !(chosenTrackerSchedule.isEmpty || chosenTrackerName.isEmpty || chosenCategoryName.isEmpty || chosenTrackerEmoji.isEmpty || chosenTrackerColor == .white)
        }
        return !(chosenTrackerName.isEmpty || chosenCategoryName.isEmpty || chosenTrackerEmoji.isEmpty || chosenTrackerColor == .white)
    }
    
    private func setCreateButtonActive(_ isActive: Bool) {
        if isActive {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor(resource: .ypBlack)
        }
    }
}

// MARK: - Extensions

extension CreateTrackerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            if trackerConfig.isRegularTracker {
                return 2
            }
            return 1
        default:
            return 1
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
            cell.delegate = self
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
        
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: EmojiHeaderCell.reuseIdentifier,
                for: indexPath
            ) as? EmojiHeaderCell else {
                print("Failed to dequeue EmojiHeaderCell")
                return UITableViewCell()
            }
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionOfEmojiCell.reuseIdentifier,
                for: indexPath
            ) as? CollectionOfEmojiCell else {
                print("Failed to dequeue CollectionOfEmojiCell")
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure()
            return cell
            
        case 4:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ColorHeaderCell.reuseIdentifier,
                for: indexPath
            ) as? ColorHeaderCell else {
                print("Failed to dequeue ColorHeaderCell")
                return UITableViewCell()
            }
            return cell
            
        case 5:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionOfColorsCell.reuseIdentifier,
                for: indexPath
            ) as? CollectionOfColorsCell else {
                print("Failed to dequeue CollectionOfColorsCell")
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure()
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

extension CreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
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
                chosenTrackerSchedule = sortedDays
                daysString = sortedDays.map { $0.shortRuName }.joined(separator: ", ")
            }
            
            trackerConfig.navigationCellSubtitles[1] = daysString
            
            let indexPath = IndexPath(row: 1, section: 1)
            tableView.reloadRows(at: [indexPath], with: .none)
            
            setCreateButtonActive(isReadyToCreateTracker(for: trackerConfig))
        }
    }
}

extension CreateTrackerViewController: TextFieldCellDelegate {
    func textFieldDidEndEditing(with text: String?) {
        guard let text = text else { return }
        if !text.isEmpty {
            chosenTrackerName = text
            setCreateButtonActive(isReadyToCreateTracker(for: trackerConfig))
            return
        }
    }
}

extension CreateTrackerViewController: CollectionOfEmojiCellDelegate {
    
    func didSelectEmoji(_ emoji: String) {
        chosenTrackerEmoji = emoji
        setCreateButtonActive(isReadyToCreateTracker(for: trackerConfig))
    }
    
    func didDeselectEmoji(_ emoji: String) {
        chosenTrackerEmoji = ""
        setCreateButtonActive(isReadyToCreateTracker(for: trackerConfig))
    }
}

extension CreateTrackerViewController: CollectionOfColorsCellDelegate {
    
    func didSelectColor(_ color: UIColor) {
        chosenTrackerColor = color
        setCreateButtonActive(isReadyToCreateTracker(for: trackerConfig))
    }
    
    func didDeselectColor(_ color: UIColor) {
        chosenTrackerColor = .white
        setCreateButtonActive(isReadyToCreateTracker(for: trackerConfig))
    }
}
