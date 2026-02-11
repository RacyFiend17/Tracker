import UIKit

final class CategoryCell: UITableViewCell {
    
    static let reuseIdentifier = "CategoryCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .ypLightGray).withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let checkmark: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .checkmark))
        imageView.tintColor = .clear
        return imageView
    }()
    
    private let separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        separator.isHidden = true
        return separator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubviews([containerView, separatorView, titleLabel, checkmark])
        contentView.translatesAutoResizingMaskFalseTo(contentView.subviews)
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: checkmark.trailingAnchor, constant: -1),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            checkmark.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            checkmark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmark.heightAnchor.constraint(equalToConstant: 24),
            checkmark.widthAnchor.constraint(equalToConstant: 24),
            
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configure(title: String, showSeparator: Bool, roundedCorners: UIRectCorner?, isSelected: Bool) {
        titleLabel.text = title
        separatorView.isHidden = !showSeparator
        checkmark.isHidden = !isSelected
        
        if let corners = roundedCorners {
            containerView.layer.cornerRadius = 16
            containerView.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            containerView.layer.cornerRadius = 0
        }
    }
    
    func changeCheckmarkVisibility(isVisible: Bool) {
        checkmark.isHidden = !isVisible
    }
}

