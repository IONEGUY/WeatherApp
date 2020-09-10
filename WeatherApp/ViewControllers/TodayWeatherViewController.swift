import UIKit
import SnapKit

class TodayWeatherViewController: UIViewController, Initializable {
    private var weatherBriefInfoContainer = UIView()
    private var weatherDetailedInfoContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .yellow
        stackView.axis = .horizontal
        return stackView
    }()
    private var weatherIcon: UIImageView = UIImageView()
    private var city: UILabel = UILabel()
    private var temperature: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30.0)
        label.textColor = .blue
        return label
    }()
    private var shareButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.share, for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    private var topOffset = 70
    private var weatherItem: WeatherItem?
    private var cityInfo: City?
    private var didSetupConstraints = false
    private var viewModel: TodayWeatherViewModel?
    private var errorHandler = AlertErrorMessageHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Strings.today
        view.backgroundColor = .white
        
        shareButton.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        
        view.addSubview(weatherBriefInfoContainer)
        view.addSubview(weatherDetailedInfoContainer)
        weatherBriefInfoContainer.addSubview(weatherIcon)
        weatherBriefInfoContainer.addSubview(city)
        weatherBriefInfoContainer.addSubview(temperature)
        view.addSubview(shareButton)
        
        view.setNeedsUpdateConstraints()
    }
    
    @objc private func shareButtonPressed() {
        let shareData = [ viewModel?.weatherSummary ]
        let activityViewController = UIActivityViewController(activityItems: shareData as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop,
                                                         UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            weatherBriefInfoContainer.snp.makeConstraints { make in
                make.left.top.right.equalToSuperview()
                make.bottom.equalTo(temperature.snp.bottom).offset(50)
            }
            weatherIcon.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(100)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(100)
            }
            city.snp.makeConstraints { make in
                make.top.equalTo(weatherIcon.snp.bottom).offset(-10)
                make.centerX.equalToSuperview()
            }
            temperature.snp.makeConstraints { make in
                make.top.equalTo(city.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }
            weatherDetailedInfoContainer.snp.makeConstraints { make in
                make.centerY.equalToSuperview().offset(topOffset)
                make.right.left.equalToSuperview().offset(0)
            }
            shareButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-100)
                make.centerX.equalToSuperview()
            }

            didSetupConstraints = true
        }

        super.updateViewConstraints()
    }
    
    func initialize(withData data: Any) {
        guard let result = data as? Result<Weather, Error> else { return }
        let weatherModel: Weather?
        switch result {
            case .success(let success):
                weatherModel = success
            case .failure(let error):
                shareButton.isHidden = true
                errorHandler.handle(error.localizedDescription)
                weatherModel = CashHelper.weather
        }
        self.viewModel = TodayWeatherViewModel(weatherModel)
        self.createUI()
    }
    
    private func createUI() {
        weatherIcon.initWith(url: viewModel?.weatherIconUrl ?? String.empty)
        city.text = viewModel?.cityName
        temperature.text = viewModel?.temperature
        
        createDetailedWeatherSection()
    }
    
    private func createDetailedWeatherSection() {
        createWeatherDetailedInfoItem(
            iconName: "rain",
            value: viewModel?.rainValue,
            topOffset: -topOffset)
        createWeatherDetailedInfoItem(
            iconName: "wind",
            value: viewModel?.windValue)
        createWeatherDetailedInfoItem(
            iconName: "precipiation",
            value: viewModel?.precipiationValue,
            topOffset: -topOffset)
        createWeatherDetailedInfoItem(
            iconName: "direction",
            value: viewModel?.directionValue)
        createWeatherDetailedInfoItem(
            iconName: "pressure",
            value: viewModel?.pressureValue,
            topOffset: -topOffset)
        
        view.setNeedsUpdateConstraints()
    }
    
    private func createWeatherDetailedInfoItem(iconName: String, value: String?, topOffset: Int = 0) {
        guard let value = value else { return }
        
        let weatherDetailedInfoItem = buildWeatherDetailedInfoItem(iconName, value, topOffset)
        weatherDetailedInfoContainer.addArrangedSubview(weatherDetailedInfoItem.view)
        createConstraintsForWeatherDetailedInfoItem(weatherDetailedInfoItem)
    }
    
    private func buildWeatherDetailedInfoItem(_ iconName: String, _ value: String?, _ topOffset: Int = 0)
        -> (view: UIView, image: UIImageView, valueLabel: UILabel) {
        let view = UIView()
        let valueLabel = UILabel()
        valueLabel.font = UIFont.systemFont(ofSize: 12)
        valueLabel.text = value
        let image = UIImageView(image: UIImage(named: iconName))
        image.tintColor = .blue
        view.addSubview(image)
        view.addSubview(valueLabel)
        return (view, image, valueLabel)
    }
    
    private func createConstraintsForWeatherDetailedInfoItem(_ weatherDetailedInfoItem: (view: UIView, image: UIImageView, valueLabel: UILabel)) {
        weatherDetailedInfoItem.view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topOffset)
            make.height.width.equalTo(50)
            make.top.equalToSuperview().offset(10)
        }
        weatherDetailedInfoItem.image.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(0)
        }
        weatherDetailedInfoItem.valueLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherDetailedInfoItem.image).offset(40)
            make.centerX.equalToSuperview()
        }
    }
}
