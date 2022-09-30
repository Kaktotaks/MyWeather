//
//  WeatherTableViewCell.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 23.09.2022.
//

import UIKit
import Kingfisher
import SnapKit

class WeatherTableViewCell: UITableViewCell {
    static let identifier = "WeatherTableViewCell"

    private lazy var dayLabel: UILabel = {
        let value = UILabel()
        value.font = Constants.Fonts.smallFont
        value.textAlignment = .center
        return value
    }()

    private lazy var heightTempLabel: UILabel = {
        let value = UILabel()
        value.font = Constants.Fonts.smallFont
        return value
    }()

    private lazy var lowTempLabel: UILabel = {
        let value = UILabel()
        value.font = Constants.Fonts.smallFont
        return value
    }()

    private lazy var iconImageView: UIImageView = {
        let value = UIImageView()
        value.isUserInteractionEnabled = true
        value.contentMode = .scaleAspectFit
        return value
    }()

    private lazy var myBackgroundView: UIImageView = {
        let value = UIImageView()
        value.image = UIImage(named: "tableViewCellBackground")
        value.clipsToBounds = true
        value.layer.cornerRadius = self.contentView.frame.height / 4
        value.isUserInteractionEnabled = true
        return value
    }()

    func configure(with model: Daily) {
        guard let dateTime = model.dt else { return }
        guard let temp = model.temp else { return }

        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(dateTime)))
        self.lowTempLabel.text = String(describing: Int(temp.min ?? 0)) + "°"
        self.heightTempLabel.text = String(describing: Int(temp.max ?? 0)) + "°"

        let iconName = model.weather?.first?.icon ?? "noWeather"
        let iconURL = URL(string: "http://openweathermap.org/img/wn/\(iconName)@2x.png")

        self.iconImageView.kf.setImage(with: iconURL)
    }

    private func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else { return "" }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Monday
        return formatter.string(from: inputDate)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setUpUI()
    }

}

extension WeatherTableViewCell {
    private func setUpUI() {
        contentView.addSubview(myBackgroundView)
        myBackgroundView.addSubview(dayLabel)
        myBackgroundView.addSubview(heightTempLabel)
        myBackgroundView.addSubview(lowTempLabel)
        myBackgroundView.addSubview(iconImageView)

        myBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }

        dayLabel.snp.makeConstraints {
            $0.leftMargin.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(4)
        }

        iconImageView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(4)
            $0.height.equalToSuperview()
        }

        heightTempLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.rightMargin.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(8)
            $0.height.equalToSuperview()
        }

        lowTempLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(heightTempLabel).inset(70)
            $0.width.equalToSuperview().dividedBy(8)
            $0.height.equalToSuperview()
        }
    }

}
