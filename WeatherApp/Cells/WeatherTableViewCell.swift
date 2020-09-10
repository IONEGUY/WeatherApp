import UIKit
import SnapKit

class WeatherTableViewCell: UITableViewCell {
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    private var temperature: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30.0)
        label.textColor = .blue
        label.textAlignment = .center
        return label
    }()
    private var weatherDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    private var weatherIcon = UIImageView()
    private var weatherContainer = UIView()
    
    private var viewModel: WeatherCellViewModel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureElements() {
        self.contentView.addSubview(weatherIcon)
        weatherContainer.addSubview(timeLabel)
        weatherContainer.addSubview(weatherDescription)
        self.contentView.addSubview(weatherContainer)
        self.contentView.addSubview(temperature)
    }

    func configureConstraints() {
        configureElements()
        weatherIcon.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
        weatherContainer.snp.makeConstraints { make in
            make.left.equalTo(weatherIcon.snp.right).offset(20)
            make.center.equalToSuperview().offset(0)
        }
        timeLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().offset(0)
            make.bottom.equalTo(weatherDescription).offset(-15)
        }
        weatherDescription.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview().offset(0)
        }
        temperature.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.bottom.equalToSuperview().offset(0)
        }
    }

    func initCell(_ weatherItem: WeatherItem) {
        viewModel = WeatherCellViewModel(weatherItem)
        weatherIcon.initWith(url: viewModel.iconUrl)
        timeLabel.text = viewModel.time
        weatherDescription.text = viewModel.weatherDescription
        temperature.text = viewModel.temperature
    }
}
