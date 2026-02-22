import UIKit

final class ColorCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ColorCell"
    
    // MARK: - UI
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - State
    private var isManuallySelected: Bool = false
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public API
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
        updateBorder()
    }
    
    func colorOfCell() -> UIColor? {
        return colorView.backgroundColor
    }
    
    func didSelect() {
        isManuallySelected = true
        updateBorder()
    }
    
    func didDeselect() {
        isManuallySelected = false
        updateBorder()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isManuallySelected = false
        updateBorder()
    }
    
    // MARK: - Theme Handling
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateBorder()
        }
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 3
        contentView.backgroundColor = .clear
        
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: 52),
            contentView.heightAnchor.constraint(equalToConstant: 52),
            
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
        
        updateBorder()
    }
    
    // MARK: - Border Logic
    private func updateBorder() {
        let borderUIColor: UIColor
        
        if isManuallySelected {
            borderUIColor = (colorView.backgroundColor ?? .clear)
                .withAlphaComponent(0.3)
        } else {
            borderUIColor = UIColor(resource: .ypWhite)
                .withAlphaComponent(0.3)
        }
        
        contentView.layer.borderColor =
            borderUIColor
                .resolvedColor(with: traitCollection)
                .cgColor
    }
}
