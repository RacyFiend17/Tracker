import UIKit

final class StatisticsViewController: UIViewController {
    
    private lazy var errorImageView: UIImageView = {
        let errorImageView = UIImageView(image: UIImage(resource: .noStatisticsError))
        errorImageView.contentMode = .scaleAspectFit
        return errorImageView
    } ()
    
    private lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.font = .systemFont(ofSize: 12, weight: .medium)
        errorLabel.text = "statisticsView.no_statistics_error".localized
        return errorLabel
    } ()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.text = "statistics".localized
        return titleLabel
    } ()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        
        return stackView
    }()
    
    var statisticsService: StatisticsServiceProtocol
    
    init(statisticsService: StatisticsServiceProtocol) {
        self.statisticsService = statisticsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        showErrorLabelAndImageViewOrCollectionView()
        
        statisticsService.onStatisticsChanged = {
            [weak self] in
            DispatchQueue.main.async {
                self?.setupCards()
                self?.showErrorLabelAndImageViewOrCollectionView()
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        view.addSubviews([titleLabel, errorLabel, errorImageView, stackView])
        setupCards()
        view.translatesAutoResizingMaskFalseTo(view.subviews)
        
        setupConstraints()
    }
    
    private func setupCards() {
        
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let bestPeriod = StatisticCardView(
            value: String(statisticsService.bestPeriod),
            title: NSLocalizedString("statisticsView.best_period", comment: "")
        )
        
        let idealDays = StatisticCardView(
            value: String(statisticsService.perfectDays),
            title: NSLocalizedString("statisticsView.ideal_days", comment: "")
        )
        
        let completed = StatisticCardView(
            value: String(statisticsService.completedTrackers),
            title: NSLocalizedString("statisticsView.count_of_done_trackers", comment: "")
        )
        
        let average = StatisticCardView(
            value: String(statisticsService.averageTasksPerDay),
            title: NSLocalizedString("statisticsView.average_amount", comment: "")
        )
        
        [bestPeriod, idealDays, completed, average].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func showErrorLabelAndImageViewOrCollectionView() {
        if true {
            errorLabel.isHidden = true
            errorImageView.isHidden = true
            stackView.isHidden = false
        } else {
            errorLabel.isHidden = false
            errorImageView.isHidden = false
            stackView.isHidden = true
        }
    }
    
    @objc private func setupConstraints () {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77)
        ])
    }
}
    
