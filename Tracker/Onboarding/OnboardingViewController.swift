import UIKit

final class OnboardingViewController: UIPageViewController {
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = UIColor(resource: .ypBlack)
        pageControl.pageIndicatorTintColor = UIColor(resource: .ypBlack).withAlphaComponent(0.3)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var excitementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("onboarding.cta.start", comment: ""), for: .normal)
        button.backgroundColor = .ypBlack
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(excitementButtonDidTap), for: .touchUpInside)
        
        return button
    } ()
    
    lazy var pages: [UIViewController] = {
        let firstVC = PageViewController(indexOfViewController: 0)
        let secondVC = PageViewController(indexOfViewController: 1)
        
        return [firstVC, secondVC]
    }()
    
    override init(transitionStyle: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]?) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        setupUI()
        
    }
    
    private func setupUI() {
        view.addSubviews([pageControl, excitementButton])
        view.translatesAutoResizingMaskFalseTo(view.subviews)
        setupConstraints()
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: excitementButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            excitementButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            excitementButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            excitementButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            excitementButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func excitementButtonDidTap() {
        AppSettings.isOnboardingCompleted = true
        AppFlow.switchToMainApp()
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentViewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = currentViewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentViewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = currentViewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first, let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
