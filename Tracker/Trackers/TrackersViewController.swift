import UIKit

final class TrackersViewController: UIViewController {
    
    let calendar = Calendar.current
    private var trackerStore: TrackerStoreProtocol
    private var trackerRecordStore: TrackerRecordStoreProtocol
    
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
    
    private lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.placeholder = "Поиск"
        searchTextField.backgroundColor = UIColor(resource: .lightGrayForSearchField).withAlphaComponent(0.12)
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.masksToBounds = true
        searchTextField.borderStyle = .none
        searchTextField.clearButtonMode = .whileEditing
        return searchTextField
    }()
    
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
        collectionView.register(TrackerCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerCellHeader.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    } ()
    
    init(trackerStore: TrackerStoreProtocol, trackerRecordStore: TrackerRecordStoreProtocol) {
        self.trackerStore = trackerStore
        self.trackerRecordStore = trackerRecordStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerStore.onChange = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.showErrorLabelAndImageViewOrCollectionView()
            }
        }
        
        trackerStore.updateFilter(date: datePicker.date)
        
        setupUI()
        showErrorLabelAndImageViewOrCollectionView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubviews([addButton, titleLabel, searchTextField, datePicker, dateLabel, collectionView, errorLabel, errorImageView])
        view.translatesAutoResizingMaskFalseTo(view.subviews)
        
        setupConstraints()
    }

    @objc func dismissKeyboard() {
    view.endEditing(true)
}
    
    @objc private func setupConstraints () {
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: 10),
            
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            
            datePicker.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            
            dateLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateLabel.heightAnchor.constraint(equalToConstant: 34),
            dateLabel.widthAnchor.constraint(equalToConstant: 77),
            
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func showErrorLabelAndImageViewOrCollectionView() {
//        if categoriesForDate(date: datePicker.date).isEmpty{
        if trackerStore.numberOfSections() == 0 {
            collectionView.isHidden = true
            errorLabel.isHidden = false
            errorImageView.isHidden = false
        } else {
            collectionView.reloadData()
            collectionView.isHidden = false
            errorLabel.isHidden = true
            errorImageView.isHidden = true
        }
    }

    private func textForDateLabel() -> String {
        return dateFormatter.string(from: datePicker.date)
    }
    
    private func shouldEnableButton(for date: Date) -> Bool {
        return date < Date()
    }
    
    @objc private func addButtonDidTap() {
        let vc = CreateTrackerTypeViewController()
        vc.delegate = self
        vc.dateOfTrackerCreation = datePicker.date.withoutTime
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func datePickerValueChanged() {
        dateLabel.text = textForDateLabel()
        trackerStore.updateFilter(date: datePicker.date)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackerStore.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerStore.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerCellHeader.reuseIdentifier, for: indexPath) as? TrackerCellHeader else { fatalError("There is no TrackerCellHeader")
            }
            view.titleLabel.text = trackerStore.categoryTitle(at: indexPath.section)
            return view
        default: return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.reuseIdentifier, for: indexPath) as? TrackerCell else {
            fatalError("There is no TrackerCell")
        }
        
        let tracker = trackerStore.tracker(at: indexPath)
        
        let completedDaysCount = trackerRecordStore.completedDaysCount(for: tracker.id)
        let isCompleted = trackerRecordStore.isTrackerCompleted(tracker.id, on: datePicker.date)
        let isEnabled = shouldEnableButton(for: datePicker.date)
        cell.configure(tracker: tracker, completedDaysCount: completedDaysCount, isCompleted: isCompleted, isEnabled: isEnabled)
        
        cell.delegate = self
        
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftInset: CGFloat = 16
        let rightInset: CGFloat = 16
        let interItemSpacing: CGFloat = 9
        let width = (collectionView.frame.width - leftInset - rightInset - interItemSpacing * 2) / 2
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 54)
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func didTapCompleteButton(_ cell: TrackerCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let tracker = trackerStore.tracker(at: indexPath)
        trackerRecordStore.toggleTracker(tracker.id, on: datePicker.date)
        
        collectionView.reloadData()
    }
}

extension TrackersViewController: CreateTrackerViewControllerDelegate {
    func didCreateTracker(_ tracker: Tracker, with categoryName: String) {
        trackerStore.addTracker(tracker, categoryTitle: categoryName)
    }
}

