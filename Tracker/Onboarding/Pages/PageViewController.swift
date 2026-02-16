import UIKit

final class PageViewController: UIViewController {
    
    let indexOfViewController: Int
    
    init(indexOfViewController: Int) {
        self.indexOfViewController = indexOfViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .systemFont(ofSize: 32, weight: .bold)
        textLabel.textAlignment = .center
        textLabel.textColor = .black
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        
        return textLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        view.addSubviews([imageView, textLabel])
        view.translatesAutoResizingMaskFalseTo(view.subviews)
        setupConstraints()
        
        switch indexOfViewController {
        case 0:
            imageView.image = UIImage(resource: .firstOnboardingPage)
            textLabel.text = NSLocalizedString("onboarding.page_tracking.title", comment: "")
        case 1:
            imageView.image = UIImage(resource: .secondOnboardingPage)
            textLabel.text = NSLocalizedString("onboarding.page_freedom.title", comment: "")
        default:
            break
        }
    }
    
    @objc private func setupConstraints () {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 460),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

