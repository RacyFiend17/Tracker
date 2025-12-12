import UIKit

protocol CollectionOfEmojiCellDelegate: AnyObject {
    func didSelectEmoji(_ emoji: String)
    func didDeselectEmoji(_ emoji: String)
}

final class CollectionOfEmojiCell: UITableViewCell {
    
    static let reuseIdentifier: String = "CollectionOfEmojiCell"
    weak var delegate: CollectionOfEmojiCellDelegate?
    
    private let arrayOfEmoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪", "💀", "🤯", "💩", "🤙", "💪", "💫", "🎈", "🎁", "🎊", "🎉", "🐸", "🐣"]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupUI(){
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            
            contentView.heightAnchor.constraint(equalToConstant: 204)
        ])
    }
}

extension CollectionOfEmojiCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(arrayOfEmoji.count / 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else {
            fatalError("There is no EmojiCell")
        }
        let indexOfEmoji = indexPath.section * 6 + indexPath.item
        let emoji = arrayOfEmoji[indexOfEmoji]
        cell.configure(with: emoji)
        
        return cell
    }
}

extension CollectionOfEmojiCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else {
            fatalError("There is no EmojiCell")
        }
        guard let emoji = cell.emojiOfCell() else {
            fatalError("There is no emoji in EmojiCell")
        }
        cell.didSelect()
        delegate?.didSelectEmoji(emoji)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else {
            fatalError("There is no EmojiCell")
        }
        guard let emoji = cell.emojiOfCell() else {
            fatalError("There is no emoji in EmojiCell")
        }
        cell.didDeselect()
        delegate?.didDeselectEmoji(emoji)
    }
}
