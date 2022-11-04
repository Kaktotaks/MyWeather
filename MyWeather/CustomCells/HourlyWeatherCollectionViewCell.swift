//
//  HourlyWeatherCollectionViewCell.swift.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 02.10.2022.
//

import UIKit
import Kingfisher

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants and Variables
    static let identifier = "HourlyWeatherCollectionViewCell"

    private lazy var myBackgroundView: UIImageView = {
        let value = UIImageView()
        value.contentMode = .scaleAspectFill
        value.image = UIImage(named: "collectionViewCellBackground")
        value.clipsToBounds = true
        value.layer.cornerRadius = self.contentView.frame.height / 5
        value.isUserInteractionEnabled = true
        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()

     lazy var hourLabel: UILabel = {
        let value = UILabel()
        value.font = Constants.Fonts.smallFont
        value.textAlignment = .center
        return value
    }()

    private lazy var iconImageView: UIImageView = {
        let value = UIImageView()
        value.isUserInteractionEnabled = true
        value.contentMode = .scaleAspectFit
        return value
    }()

    private lazy var tempLabel: UILabel = {
        let value = UILabel()
        value.font = Constants.Fonts.smallFont
        value.textAlignment = .center
        return value
    }()

    // MARK: - functions
    func configure(with model: Hourly) {
        guard let hourTime = model.dt else { return }

        self.hourLabel.text = DateFormaterManager.shared.formatDate(
            date: Date(timeIntervalSince1970: Double(hourTime)),
            dateFormat: Constants.DateFormats.hour
        )

        let iconName = model.weather?.first?.icon ?? "01n"
        let iconURL = URL(string: "http://openweathermap.org/img/wn/\(iconName)@2x.png")
        self.iconImageView.kf.setImage(with: iconURL)

        self.tempLabel.text = String(describing: Int(model.temp ?? 0)) + "°"
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setUpUI()
    }

    private func setUpUI() {
        contentView.addSubview(myBackgroundView)
        myBackgroundView.addSubview(hourLabel)
        myBackgroundView.addSubview(iconImageView)
        myBackgroundView.addSubview(tempLabel)

        myBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(2)
        }

        hourLabel.snp.makeConstraints {
            $0.topMargin.equalToSuperview().inset(6)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(4)
        }

        iconImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(4)
        }

        tempLabel.snp.makeConstraints {
            $0.bottomMargin.equalToSuperview().inset(2)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(4)
        }
    }
}
