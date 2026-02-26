import UIKit

// MARK: - Protocols

protocol EditTrackerViewControllerDelegate: AnyObject {
    func didEditTracker(_ tracker: Tracker, with categoryName: String)
}

// MARK: - EditTrackerViewController

final class EditTrackerViewController: UIViewController {
    
    // MARK: - Delegates
    
    weak var delegate: EditTrackerViewControllerDelegate?
    
    // MARK: - Properties
    
    private var editableTracker: Tracker
    private var trackerRecordStore: TrackerRecordStoreProtocol
    private var trackerStore: TrackerStoreProtocol
    
    private var trackerConfig: AddTrackerConfig
    private var chosenTrackerSchedule: [Weekday] = []
    private var chosenTrackerName: String = ""
    private var chosenCategoryName: String = ""
    private var chosenTrackerEmoji: String = ""
    private var chosenTrackerColor: UIColor = .white
    private var dateOfTrackerCreation = Date().withoutTime
    
    // MARK: - UI Components
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .ypBlack
        titleLabel.text = editableTracker.trackerType == .habit ? "edit_habit".localized : "edit_not_regular_event".localized
        
        return titleLabel
    } ()
    
    private lazy var daysCountLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .ypBlack
        titleLabel.text = String.localizedStringWithFormat(NSLocalizedString("days_count", comment: "Number of days"), trackerRecordStore.completedDaysCount(for: editableTracker.id))
        
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
        button.setTitle("cancel".localized, for: .normal)
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
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("save".localized, for: .normal)
        button.backgroundColor = .ypBlack
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.ypWhite, for: .normal)
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        return button
    } ()
    
    // MARK: - Initializer
    
    init(editableTracker: Tracker, trackerStore: TrackerStoreProtocol, trackerRecordStore: TrackerRecordStoreProtocol) {
        self.editableTracker = editableTracker
        
        self.trackerStore = trackerStore
        self.trackerRecordStore = trackerRecordStore
        
        self.trackerConfig = editableTracker.trackerType == .habit ? HabitConfig() : IrregularConfig()
        self.chosenTrackerSchedule = editableTracker.schedule
        self.chosenTrackerName = editableTracker.name
        self.chosenCategoryName = trackerStore.categoryTitle(for: editableTracker)
        self.chosenTrackerEmoji = editableTracker.emoji
        self.chosenTrackerColor = editableTracker.color
        self.dateOfTrackerCreation = editableTracker.dateCreated

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
        setupInitialValues()
        setupGestureRecognizers()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .ypWhite)
        
        view.addSubviews([titleLabel, daysCountLabel, tableView, saveButton, cancelButton])
        view.translatesAutoResizingMaskFalseTo(view.subviews)
        
        setupConstraints()
        
    }
    
    private func setupInitialValues(){
        trackerConfig.navigationCellSubtitles[0] = chosenCategoryName
            
            if trackerConfig.isRegularTracker {
                if chosenTrackerSchedule.count == 7 {
                    trackerConfig.navigationCellSubtitles[1] = "every_day".localized
                } else {
                    let sorted = chosenTrackerSchedule.sorted { $0.rawValue < $1.rawValue }
                    trackerConfig.navigationCellSubtitles[1] =
                        sorted.map { $0.localizedShortName }.joined(separator: ", ")
                }
            }
    }
    
    @objc private func setupConstraints () {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            daysCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            daysCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            daysCountLabel.heightAnchor.constraint(equalToConstant: 38),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 142),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalTo: saveButton.widthAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func cancelButtonDidTap() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonDidTap() {
        if chosenTrackerName.isEmpty || chosenCategoryName.isEmpty || chosenTrackerEmoji.isEmpty || chosenTrackerColor == .white { return }
        else {
            if trackerConfig.isRegularTracker {
                if chosenTrackerSchedule.isEmpty { return }
                let newTracker = Tracker(
                    id: editableTracker.id,
                    name: chosenTrackerName,
                    color: chosenTrackerColor,
                    emoji: chosenTrackerEmoji,
                    schedule: chosenTrackerSchedule,
                    trackerType: TrackerType.habit,
                    dateCreated: dateOfTrackerCreation
                )
                dismiss(animated: true)
                delegate?.didEditTracker(newTracker, with: chosenCategoryName)
            } else {
                let newTracker = Tracker(
                    id: editableTracker.id,
                    name: chosenTrackerName,
                    color: chosenTrackerColor,
                    emoji: chosenTrackerEmoji,
                    schedule: Weekday.allCases,
                    trackerType: TrackerType.habit,
                    dateCreated: dateOfTrackerCreation
                )
                
                dismiss(animated: true)
                delegate?.didEditTracker(newTracker, with: chosenCategoryName)
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
}

// MARK: - Extensions

extension EditTrackerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            if editableTracker.trackerType == .habit {
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
            cell.configure(with: chosenTrackerName)
            
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
            cell.configure(emoji: chosenTrackerEmoji)
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
            cell.configure(color: chosenTrackerColor)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

extension EditTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        guard indexPath.section == 1 else { return }
        switch indexPath.row {
        case 0:
            let store = TrackerCategoryStore()
            let vm = CategoriesViewModel(store: store)
            let vc = CategoriesViewController()
            vc.initialize(viewModel: vm)
            vc.delegate = self
            self.present(vc, animated: true)
        case 1:
            let vc = ScheduleViewController()
            vc.delegate = self
            self.present(vc, animated: true)
        default :
            break
        }
    
    }
}

extension EditTrackerViewController: ScheduleViewControllerDelegate {
    func didSelectDays(_ days: Set<Weekday>) {
        guard !days.isEmpty else { return }
            
            var daysString = ""
            
            switch days.count {
            case 7:
                daysString = "every_day".localized
            default :
                let sortedDays = days.sorted { $0.rawValue < $1.rawValue }
                chosenTrackerSchedule = sortedDays
                daysString = sortedDays.map { $0.localizedShortName }.joined(separator: ", ")
            }
            
            trackerConfig.navigationCellSubtitles[1] = daysString
            
            let indexPath = IndexPath(row: 1, section: 1)
            tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension EditTrackerViewController: CategoriesViewControllerDelegate {
    func didSelectCategoryName(_ name: String) {
        chosenCategoryName = name
        
        let indexPath = IndexPath(row: 0, section: 1)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension EditTrackerViewController: TextFieldCellDelegate {
    func textFieldDidEndEditing(with text: String?) {
        guard let text = text else { return }
        if !text.isEmpty {
            chosenTrackerName = text
            return
        }
    }
}

extension EditTrackerViewController: CollectionOfEmojiCellDelegate {
    func didSelectEmoji(_ emoji: String) {
        chosenTrackerEmoji = emoji
    }
    
    func didDeselectEmoji(_ emoji: String) {
        chosenTrackerEmoji = ""
    }
}

extension EditTrackerViewController: CollectionOfColorsCellDelegate {
    func didSelectColor(_ color: UIColor) {
        chosenTrackerColor = color
    }
    
    func didDeselectColor(_ color: UIColor) {
        chosenTrackerColor = .white
    }
}
