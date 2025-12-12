import UIKit

final class ColorCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ColorCell"
    
    private let colorView: UIView = {
        let colorView = UIView()
        colorView.backgroundColor = .white
        colorView.layer.cornerRadius = 8
        colorView.layer.masksToBounds = true
        return colorView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func colorOfCell() -> UIColor? {
        return colorView.backgroundColor
    }
    
    func didSelect() {
        contentView.layer.borderColor = colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
    }
    
    func didDeselect() {
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        contentView.backgroundColor = .clear
        
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: 52),
            contentView.heightAnchor.constraint(equalToConstant: 52),
            
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
        ])
    }
}




