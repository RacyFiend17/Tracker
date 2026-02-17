import UIKit

final class CreateCategoryViewController: UIViewController {
    
    private let viewModel: CreateCategoryViewModel
    var onCategoryCreated: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "new_category".localized
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        return titleLabel
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .ypLightGray).withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "input_category_name".localized
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.addTarget(self, action: #selector(textFieldChangedContent), for: .editingChanged)
//        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        
        return textField
    }()
    
    private let deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(resource: .deleteTextFieldButton), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTextInTextField), for: .touchUpInside)
        deleteButton.isHidden = true
        return deleteButton
    }()

    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("done".localized, for: .normal)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    init(viewModel: CreateCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        
        setupGestureRecognizers()
    }
    
    //MARK: UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubviews([titleLabel, containerView, textField, deleteButton, doneButton])
        view.translatesAutoResizingMaskFalseTo(view.subviews)
    
        setupConstraints()
    }
    
    @objc private func setupConstraints () {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 75),
            
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -12),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            deleteButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 17),
            deleteButton.heightAnchor.constraint(equalToConstant: 17),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    //MARK: Binding
    private func bind() {
        viewModel.onButtonStateChanged = { [weak self] isEnabled in
            self?.doneButton.isEnabled = isEnabled
            self?.doneButton.backgroundColor = isEnabled ? .ypBlack : .ypGray
        }
        
        viewModel.onCategoryCreated = { [weak self] in
            self?.onCategoryCreated?()
            self?.dismiss(animated: true)
        }
    }
    
    // MARK: - Actions
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupGestureRecognizers(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func textFieldChangedContent() {
        deleteButton.isHidden = textField.text?.isEmpty == true
        viewModel.didChangeText(textField.text)
    }
    
    @objc private func deleteTextInTextField () {
        textField.text = ""
        deleteButton.isHidden = true
        viewModel.didChangeText(nil)
    }

    @objc private func doneButtonTapped() {
        viewModel.createCategory()
    }
}
