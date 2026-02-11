import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectDays(_ days: Set<Weekday>)
}

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    private var chosenDays: Set<Weekday> = []
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.text = "Расписание"
    
        return titleLabel
    } ()
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        tableView.isScrollEnabled = false
        
        return tableView
    } ()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = .ypBlack
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
        
        return button
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubviews([titleLabel, tableView, doneButton])
        view.translatesAutoResizingMaskFalseTo(view.subviews)
        
        setupConstraints()
    }
    
    @objc private func setupConstraints () {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc private func doneButtonDidTap() {
        delegate?.didSelectDays(chosenDays)
        dismiss(animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseIdentifier, for: indexPath) as? ScheduleCell else {
            print("Failed to dequeue ScheduleCell")
            return UITableViewCell()
        }
        
        let isLast = indexPath.row == 6
        let isFirst = indexPath.row == 0
        
        var cornerStyle: UIRectCorner? = nil
        if isFirst {
            cornerStyle = [.topLeft, .topRight]
        } else if isLast {
            cornerStyle = [.bottomLeft, .bottomRight]
        }
        
        let showSeparator = !isLast
        let title = Weekday.allCases[indexPath.row].ruName
        
        cell.configure(title: title,
                       showSeparator: showSeparator,
                       roundedCorners: cornerStyle)
        
        cell.delegate = self
        
        return cell
        
    }
}

extension ScheduleViewController: ScheduleCellDelegate {
    func switchButtonChangedValue(_ cell: ScheduleCell, isOn: Bool) {
        if isOn {
            guard let indexPath = tableView.indexPath(for: cell) else {
                print("Failed to get index path for ScheduleCell")
                return
            }
            guard let day = Weekday(rawValue: indexPath.row + 1) else {
                return
            }
            chosenDays.insert(day)
        }
    }
}
