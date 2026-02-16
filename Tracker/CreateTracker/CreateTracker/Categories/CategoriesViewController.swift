import UIKit

protocol CategoriesViewControllerDelegate: AnyObject {
    func didSelectCategoryName(_ name: String)
}

final class CategoriesViewController: UIViewController {
    
    weak var delegate: CategoriesViewControllerDelegate?
    var viewModel: CategoriesViewModel?
    
    private lazy var errorImageView: UIImageView = {
        let errorImageView = UIImageView(image: UIImage(resource: .errorTrackersLabel))
        errorImageView.contentMode = .scaleAspectFit
        return errorImageView
    } ()
    
    private lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.font = .systemFont(ofSize: 12, weight: .medium)
        errorLabel.text = "trackers_page.error_title".localized
        return errorLabel
    } ()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.text = "category".localized
        
        return titleLabel
    } ()
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        tableView.isScrollEnabled = true
        
        return tableView
    } ()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("add_category".localized, for: .normal)
        button.backgroundColor = .ypBlack
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(createButtonDidTap), for: .touchUpInside)
        
        return button
    } ()
    
    func initialize(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        viewModel?.loadCategories()
        
        setupUI()
        showErrorLabelAndImageViewOrCollectionView()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubviews([titleLabel, tableView, createButton, errorLabel, errorImageView])
        view.translatesAutoResizingMaskFalseTo(view.subviews)
        
        setupConstraints()
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
            
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 246),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func showErrorLabelAndImageViewOrCollectionView() {
        guard let numberOfRows = viewModel?.numberOfRows else { return }
        
        if numberOfRows > 0 {
            tableView.reloadData()
            tableView.isHidden = false
            errorLabel.isHidden = true
            errorImageView.isHidden = true
        } else {
            tableView.isHidden = true
            errorLabel.isHidden = false
            errorImageView.isHidden = false
        }
    }
    
    @objc private func createButtonDidTap() {
        let store = TrackerCategoryStore()
        let vm = CreateCategoryViewModel(store: store)
        let vc = CreateCategoryViewController(viewModel: vm)
        
        vc.onCategoryCreated = { [weak self] in
            self?.viewModel?.loadCategories()
        }
        
        present(vc, animated: true)
    }
    
    //MARK: Binding
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.onCategoryNameSelected = { [weak self] categoryName in
            self?.delegate?.didSelectCategoryName(categoryName)
            self?.dismiss(animated: true)
        }
        
        viewModel.onCategoriesChanged = { [weak self] in
            self?.tableView.reloadData()
            self?.showErrorLabelAndImageViewOrCollectionView()
        }
    }
}

//MARK: Extensions
extension CategoriesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
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
        
        let categoryName = viewModel?.titleForCell(at: indexPath) ?? ""
        
        cell.configure(title: categoryName,
                       showSeparator: showSeparator,
                       roundedCorners: cornerStyle,
                       isSelected: viewModel?.isSelected(at: indexPath) ?? false)
        
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectRow(at: indexPath)
    }
}
