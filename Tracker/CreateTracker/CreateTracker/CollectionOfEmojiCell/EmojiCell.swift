import UIKit

final class EmojiCell: UICollectionViewCell {
    
    static let reuseIdentifier = "EmojiCell"
    
    private let emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.textAlignment = .center
        emojiLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        emojiLabel.backgroundColor = .clear
        return emojiLabel
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func configure(with text: String) {
        emojiLabel.text = text
    }
    
    func emojiOfCell() -> String? {
        return emojiLabel.text
    }
    
    func didSelect() {
        contentView.backgroundColor = UIColor(resource: .ypLightGray)
    }
    
    func didDeselect() {
        contentView.backgroundColor = .clear
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}




