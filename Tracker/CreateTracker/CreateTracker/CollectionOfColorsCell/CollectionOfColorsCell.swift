import UIKit

protocol CollectionOfColorsCellDelegate: AnyObject {
    func didSelectColor(_ color: UIColor)
    func didDeselectColor(_ color: UIColor)
}

final class CollectionOfColorsCell: UITableViewCell {
    
    static let reuseIdentifier: String = "CollectionOfColorsCell"
    private let amountOfColors: Int = 18
    weak var delegate: CollectionOfColorsCellDelegate?
    
//    private let arrayOfColors: [UIColor] = [UIColor(resource: ._1), UIColor(resource: ._2), UIColor(resource: ._3), UIColor(resource: ._4), UIColor(resource: ._5), UIColor(resource: ._6), UIColor(resource: ._7), UIColor(resource: ._8), UIColor(resource: ._9), UIColor(resource: ._10), UIColor(resource: ._11), UIColor(resource: ._12), UIColor(resource: ._5), UIColor(resource: ._6), UIColor(resource: ._7), UIColor(resource: ._8)]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        
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

extension CollectionOfColorsCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(amountOfColors / 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as? ColorCell else {
            fatalError("There is no ColorCell")
        }
        let indexOfColor = indexPath.section * 6 + indexPath.item + 1
        guard let color = UIColor(named: "\(indexOfColor)") else {
            return cell
        }
        cell.configure(with: color)
        
        return cell
    }
}

extension CollectionOfColorsCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else {
            fatalError("There is no ColorCell")
        }
        guard let color = cell.colorOfCell() else {
            fatalError("There is no color in ColorCell")
        }
        cell.didSelect()
        delegate?.didSelectColor(color)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else {
            fatalError("There is no ColorCell")
        }
        guard let color = cell.colorOfCell() else {
            fatalError("There is no color in ColorCell")
        }
        cell.didDeselect()
        delegate?.didDeselectColor(color)
    }
}
