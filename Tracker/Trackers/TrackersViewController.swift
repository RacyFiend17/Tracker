import UIKit

final class TrackersViewController: UIViewController {
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    } ()
    
    private lazy var errorImageView: UIImageView = {
        let errorImageView = UIImageView(image: UIImage(resource: .errorTrackersLabel))
        errorImageView.contentMode = .scaleAspectFit
        return errorImageView
    } ()
    
    private lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.font = .systemFont(ofSize: 12, weight: .medium)
        errorLabel.text = "Что будем отслеживать?"
        return errorLabel
    } ()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
        button.setImage(UIImage(resource: .addTrackerButton), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    } ()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.text = "Трекеры"
        return titleLabel
    } ()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        return searchBar
    } ()
    
    private lazy var datePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return datePicker
    } ()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.backgroundColor = UIColor(resource: .lightGrayForDateLabel)
        dateLabel.layer.cornerRadius = 8
        dateLabel.layer.masksToBounds = true
        dateLabel.textAlignment = .center
        dateLabel.text = textForDateLabel()
        dateLabel.isUserInteractionEnabled = false
        
        return dateLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func textForDateLabel() -> String {
        return dateFormatter.string(from: datePicker.date)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubviews([errorImageView, errorLabel, addButton, titleLabel, searchBar, datePicker, dateLabel])
        view.translatesAutoResizingMaskFalseTo(view.subviews)
        
        setupConstraints()
    }
    
    @objc private func setupConstraints () {
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: 10),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 59),
            
            datePicker.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            
            dateLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateLabel.heightAnchor.constraint(equalToConstant: 34),
            dateLabel.widthAnchor.constraint(equalToConstant: 77),
            
        ])
    }
    
    @objc private func addButtonDidTap() {
        print("Add button was tapped")
    }
    
    @objc private func datePickerValueChanged() {
        dateLabel.text = textForDateLabel()
    }
}

