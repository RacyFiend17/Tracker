import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func filterDidSet(_ filter: TrackerFilter)
}

final class FiltersViewController: UIViewController {
    
    private var filters: [TrackerFilter] = TrackerFilter.allCases
    weak var delegate: FiltersViewControllerDelegate?
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .ypBlack
        titleLabel.text = "filters".localized
        
        return titleLabel
    } ()
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseIdentifier)
        tableView.isScrollEnabled = true
        
        return tableView
    } ()
    
    init(trackerStore: TrackerStoreProtocol) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .ypWhite)
        
        view.addSubviews([titleLabel, tableView])
        view.translatesAutoResizingMaskFalseTo(view.subviews)
        
        setupConstraints()
    }
    
    private func didSelectFilter(_ filter: TrackerFilter) {
        AppSettings.selectedFilter = filter
        delegate?.filterDidSet(filter)
        dismiss(animated: true)
    }
    
    //MARK: UI Setup
    @objc private func setupConstraints () {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
        ])
    }
}
    
    //MARK: Extensions
    extension FiltersViewController: UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 4
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseIdentifier, for: indexPath) as? FilterCell else {
                print("Failed to dequeue CategoryCell")
                return UITableViewCell()
            }
            
            let isLast = indexPath.row == tableView.numberOfRows(inSection: 0) - 1
            let isFirst = indexPath.row == 0
            
            var cornerStyle: UIRectCorner? = nil
            if isFirst {
                cornerStyle = [.topLeft, .topRight]
            } else if isLast {
                cornerStyle = [.bottomLeft, .bottomRight]
            }
            
            let showSeparator = !isLast
            
            let filterName = filters[indexPath.row].rawValue.localized
            var isFilterSelected = filters[indexPath.row] == AppSettings.selectedFilter
            
            if AppSettings.selectedFilter == .all || AppSettings.selectedFilter == .today {
                isFilterSelected = false
            }
            
            cell.configure(title: filterName,
                           showSeparator: showSeparator,
                           roundedCorners: cornerStyle,
                           isSelected: isFilterSelected
            )
            return cell
        }
    }


extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterCell else { return }
        cell.changeCheckmarkVisibility(isVisible: true)
        didSelectFilter(filters[indexPath.row])
    }
}
