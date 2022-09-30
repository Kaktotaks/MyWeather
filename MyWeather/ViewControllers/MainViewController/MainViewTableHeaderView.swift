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
//        value.image = UIImage(named: "noWeather")
        return value
    }()

    private let summaryLabel: UILabel = {
        let value = UILabel()
        value.textAlignment = .center
        value.font = Constants.Fonts.mediumFont
        return value
    }()

    private let tempLabel: UILabel = {
        let value = UILabel()
        value.textAlignment = .center
        value.font = Constants.Fonts.mediumFont
        return value
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        addSubview(myBackgroundView)
        myBackgroundView.addSubview(locationLabel)
        myBackgroundView.addSubview(currentWeatherImageView)
        myBackgroundView.addSubview(summaryLabel)
        myBackgroundView.addSubview(tempLabel)

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
            $0.topMargin.equalTo(locationLabel).inset(100)
            $0.centerX.equalToSuperview()
            $0.width.height.equalToSuperview().dividedBy(3)
        }

//        summaryLabel.snp.makeConstraints {
//            $0.
//            $0.
//        }
//
//        tempLabel.snp.makeConstraints {
//            $0.
//            $0.
//        }

    }

    func configure(with geoModel: [WeatherGeoResponse]?) {
        self.locationLabel.text = geoModel?.first?.localNames?.en
    }
}
