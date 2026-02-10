import UIKit

final class NavigationCell: UITableViewCell {
    
    static let reuseIdentifier = "NavigationCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .ypLightGray).withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .arrowForNavigationCell)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypGray
        return label
    }()
    
    private let separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        separator.isHidden = true
        return separator
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, subtitle: String?, showSeparator: Bool, roundedCorners: UIRectCorner?) {
        titleLabel.text = title
        guard let subtitle else {
            self.subtitleLabel.text = nil
            return
        }
        subtitleLabel.text = subtitle
        separatorView.isHidden = !showSeparator
        
        if let corners = roundedCorners {
            containerView.layer.cornerRadius = 16
            containerView.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            containerView.layer.cornerRadius = 0
        }
    }
    
    func addSubtitle(_ subtitle: String) {
        subtitleLabel.text = subtitle
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(subtitleLabel)
        
        contentView.addSubviews([verticalStackView, containerView, arrowImageView, separatorView])
        contentView.translatesAutoResizingMaskFalseTo(contentView.subviews)
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 75),
            
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24),
            
            verticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: -16),
            verticalStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
