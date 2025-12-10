import UIKit

final class TextFieldCell: UITableViewCell {

    static let reuseIdentifier = "TextFieldCell"
    weak var delegate: TextFieldCellDelegate?

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .ypGray).withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.addTarget(self, action: #selector(textFieldChangedContent), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        
        return textField
    }()
    
    private let deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(resource: .deleteTextFieldButton), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTextInTextField), for: .touchUpInside)
        deleteButton.isHidden = true
        return deleteButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textFieldChangedContent() {
        deleteButton.isHidden = textField.text?.isEmpty == true
    }
    
    @objc private func textFieldDidEndEditing(){
        
        delegate?.textFieldDidEndEditing(with: textField.text)
    }
    
    @objc private func deleteTextInTextField () {
        textField.text = ""
        deleteButton.isHidden = true
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubviews([containerView, textField, deleteButton])
        contentView.translatesAutoResizingMaskFalseTo(contentView.subviews)
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 75),
            
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -12),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 17),
            deleteButton.heightAnchor.constraint(equalToConstant: 17),
                        
        ])
    }
}

protocol TextFieldCellDelegate: AnyObject {
    func textFieldDidEndEditing(with text: String?)
}
