//
//  MainViewHeader.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 29.09.2022.
//

import UIKit
import SnapKit

final class MainViewTableHeaderView: UIView {
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
        value.text = "12"
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

    override func layoutSubviews() {
        super.layoutSubviews()

        addSubview(myBackgroundView)
        myBackgroundView.addSubview(locationLabel)
        myBackgroundView.addSubview(currentWeatherImageView)
        myBackgroundView.addSubview(currentWeatherTempLabel)
        myBackgroundView.addSubview(descriptionLabel)
        myBackgroundView.addSubview(maxTempLabel)
        myBackgroundView.addSubview(minTempLabel)

        setUpConstraintsForHeader()
    }

    private func setUpConstraintsForHeader() {
        myBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }

        locationLabel.snp.makeConstraints {
            $0.topMargin.equalToSuperview().inset(20)
            $0.height.equalTo(40)
            $0.width.equalToSuperview().inset(-40)
            $0.centerX.equalToSuperview()
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

    }

}
