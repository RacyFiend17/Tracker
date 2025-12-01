import UIKit

final class TrackerCell: UICollectionViewCell {
    weak var delegate: TrackerCellDelegate?
    static let reuseIdentifier = "TrackerCell"
    
    private let containerView = UIStackView()
    private let spacerView = UIView()
    private let nameLabel = UILabel()
    private let emojiLabel = UILabel()
    private let backgroundCardView = UIView()
    private let daysLabel = UILabel()
    private let completeButton = UIButton()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .white
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        containerView.axis = .vertical
        containerView.addArrangedSubview(spacerView)
        containerView.addArrangedSubview(nameLabel)
        
        emojiLabel.font = .systemFont(ofSize: 12, weight: .medium)
        emojiLabel.backgroundColor = .white.withAlphaComponent(0.3)
        emojiLabel.textAlignment = .center
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.clipsToBounds = true
        
        backgroundCardView.layer.cornerRadius = 16
        backgroundCardView.clipsToBounds = true
        backgroundCardView.backgroundColor = UIColor(resource: .lightGrayForDateLabel)
        
        daysLabel.font = .systemFont(ofSize: 12, weight: .medium)
        daysLabel.textColor = UIColor(resource: .ypBlack)
        
        completeButton.addTarget(self, action: #selector(completeButtonDidTapped), for: .touchUpInside)
        
        contentView.addSubviews([backgroundCardView, containerView, emojiLabel, daysLabel, completeButton])
        contentView.translatesAutoResizingMaskFalseTo(contentView.subviews)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: backgroundCardView.bottomAnchor, constant: -12),
            
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            backgroundCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundCardView.heightAnchor.constraint(equalToConstant: 90),
            
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            daysLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -54),
            
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor)
        ])
    }
    
    @objc private func completeButtonDidTapped() {
        delegate?.didTapCompleteButton(self)
    }
    
    func changeButtonState(isCompleted: Bool) {
        isCompleted ? completeButton.setImage(UIImage(resource: .doneCheckMark), for: .normal) : completeButton.setImage(UIImage(resource: .plusCheckMark), for: .normal)
    }
    
    func configure(tracker: Tracker, completedDaysCount: Int, isCompleted: Bool, isEnabled: Bool) {
        nameLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        backgroundCardView.backgroundColor = tracker.color
        daysLabel.text = daysWord(for: completedDaysCount)
        completeButton.tintColor = tracker.color
        if isEnabled {
            isCompleted ? completeButton.setImage(UIImage(resource: .doneCheckMark), for: .normal) : completeButton.setImage(UIImage(resource: .plusCheckMark), for: .normal)
        } else {
            completeButton.setImage(UIImage(resource: .doneCheckMark), for: .normal)
        }
        
    }
    
    private func daysWord(for count: Int) -> String {
            switch count % 10 {
            case 1 where count % 100 != 11: return "\(count) день"
            case 2...4 where !(12...14).contains(count % 100): return "\(count) дня"
            default: return "\(count) дней"
            }
        }
    
    func changeDaysCountInDaysLabel(_ completedDaysCount: Int){
        daysLabel.text = daysWord(for: completedDaysCount)
    }
    
    func changeCompleteButtonState(_ isDone: Bool) {
        isDone ? completeButton.setImage(UIImage(resource: .doneCheckMark), for: .normal) : completeButton.setImage(UIImage(resource: .plusCheckMark), for: .normal)
    }
}

protocol TrackerCellDelegate: AnyObject {
    func didTapCompleteButton(_ cell: TrackerCell)
}
