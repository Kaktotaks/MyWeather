//
//  MainViewHeader.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 29.09.2022.
//

import UIKit
import SnapKit

final class MainViewTableHeaderView: UIView {
    // MARK: - Constants and Variables
    private let myBackgroundView: UIImageView = {
        let value = UIImageView()
        value.image = UIImage(named: "mainViewBackground")
        value.clipsToBounds = true
        value.layer.cornerRadius = 40
        value.translatesAutoresizingMaskIntoConstraints = false
        return value
    }()

    let locationLabel: UILabel = {
        let value = UILabel()
        value.textAlignment = .center
        value.font = Constants.Fonts.largeFont
        value.numberOfLines = 0
        return value
    }()

    var currentWeatherImageView: UIImageView = {
        let value = UIImageView()
        value.isUserInteractionEnabled = true
        value.contentMode = .scaleAspectFit
        return value
    }()

    var currentWeatherTempLabel: UILabel = {
        let value = UILabel()
        value.textAlignment = .center
        value.font = Constants.Fonts.mediumFont
        return value
    }()

    let descriptionLabel: UILabel = {
        let value = UILabel()
        value.textAlignment = .center
        value.font = Constants.Fonts.mediumFont
        return value
    }()

    let maxTempLabel: UILabel = {
        let value = UILabel()
        value.textAlignment = .center
        value.font = Constants.Fonts.smallFont
        return value
    }()

    let minTempLabel: UILabel = {
        let value = UILabel()
        value.textAlignment = .center
        value.font = Constants.Fonts.smallFont
        return value
    }()

    let currentDateLabel: UILabel = {
        let value = UILabel()
        value.textAlignment = .center
        value.font = Constants.Fonts.timeMinFont
        return value
    }()

    let sunriseTimeLabel: UILabel = {
        let value = UILabel()
        value.textAlignment = .center
        value.font = Constants.Fonts.timeMinFont
        return value
    }()

    let sunsetTimeLabel: UILabel = {
        let value = UILabel()
        value.textAlignment = .center
        value.font = Constants.Fonts.timeMinFont
        return value
    }()

    let humidityLabel: UILabel = {
        let value = UILabel()
        value.textAlignment = .center
        value.font = Constants.Fonts.smallFont
        return value
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        addSubview(myBackgroundView)
        myBackgroundView.addSubview(locationLabel)
        myBackgroundView.addSubview(currentWeatherImageView)
        myBackgroundView.addSubview(currentWeatherTempLabel)
        myBackgroundView.addSubview(descriptionLabel)
        myBackgroundView.addSubview(maxTempLabel)
        myBackgroundView.addSubview(minTempLabel)
        myBackgroundView.addSubview(currentDateLabel)
        myBackgroundView.addSubview(sunriseTimeLabel)
        myBackgroundView.addSubview(sunsetTimeLabel)
        myBackgroundView.addSubview(humidityLabel)

        setUpConstraintsForHeader()
    }

    // MARK: - functions
    private func setUpConstraintsForHeader() {
        myBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }

        locationLabel.snp.makeConstraints {
            $0.topMargin.equalToSuperview().inset(6)
            $0.height.equalTo(60)
            $0.leftMargin.rightMargin.equalToSuperview()
        }

        currentWeatherImageView.snp.makeConstraints {
            $0.topMargin.equalTo(locationLabel).inset(40)
            $0.centerX.equalToSuperview()
            $0.width.height.equalToSuperview().dividedBy(3)
        }

        currentWeatherTempLabel.snp.makeConstraints {
            $0.topMargin.equalTo(currentWeatherImageView).inset(60)
            $0.centerX.equalToSuperview()
            $0.width.height.equalToSuperview().dividedBy(4)
        }

        descriptionLabel.snp.makeConstraints {
            $0.topMargin.equalTo(currentWeatherTempLabel).inset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        maxTempLabel.snp.makeConstraints {
            $0.topMargin.equalTo(descriptionLabel).inset(60)
            $0.centerX.equalToSuperview().offset(-40)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }

        minTempLabel.snp.makeConstraints {
            $0.topMargin.equalTo(descriptionLabel).inset(60)
            $0.centerX.equalToSuperview().offset(40)
            $0.width.equalTo(60)
            $0.height.equalTo(40)
        }

        currentDateLabel.snp.makeConstraints {
            $0.bottomMargin.leftMargin.equalToSuperview().inset(20)
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }

        sunsetTimeLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailingMargin.equalTo(maxTempLabel).inset(80)
            $0.centerY.equalToSuperview().offset(12)
        }

        sunriseTimeLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailingMargin.equalTo(maxTempLabel).inset(80)
            $0.centerY.equalToSuperview().offset(-12)
        }

        humidityLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.trailing.equalToSuperview().inset(20)
            $0.leadingMargin.equalTo(minTempLabel).offset(80)
            $0.centerY.equalToSuperview()
        }
    }
}
