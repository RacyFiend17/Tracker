import UIKit

final class StatisticCardView: UIView {
    
    // MARK: - UI
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var contentStack = UIStackView()
    private lazy var gradientLayer = CAGradientLayer()
    private lazy var borderMask = CAShapeLayer()
    
    // MARK: - Init
    
    init(value: String, title: String) {
        super.init(frame: .zero)
        setupUI()
        configure(value: value, title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .ypWhite
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        setupGradientBorder()
        setupStack()
    }
    
    private func setupStack() {
        contentStack.axis = .vertical
        contentStack.spacing = 7
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentStack.addArrangedSubview(valueLabel)
        contentStack.addArrangedSubview(titleLabel)
        
        addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func setupGradientBorder() {
        gradientLayer.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemGreen.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        
        layer.addSublayer(gradientLayer)
        
        borderMask.fillColor = UIColor.clear.cgColor
        borderMask.strokeColor = UIColor.black.cgColor
        borderMask.lineWidth = 1
        
        gradientLayer.mask = borderMask
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        
        let path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: 1, dy: 1),
            cornerRadius: 16
        )
        borderMask.path = path.cgPath
    }
    
    // MARK: - Configure
    
    func configure(value: String, title: String) {
        valueLabel.text = value
        titleLabel.text = title
    }
}
