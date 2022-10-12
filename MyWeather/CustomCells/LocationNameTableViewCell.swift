//
//  LocationNameTableViewCell.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 07.10.2022.
//

import UIKit
import SnapKit

class LocationNameTableViewCell: UITableViewCell {
    static let identifier = "LocationNameTableViewCell"

    private lazy var cityNameLabel: UILabel = {
        let value = UILabel()
        value.font = Constants.Fonts.mediumFont
        value.textAlignment = .center
        return value
    }()

    private lazy var countryNameLabel: UILabel = {
        let value = UILabel()
        value.font = Constants.Fonts.smallFont
        value.textAlignment = .center
        return value
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        setUpConstraints()
    }

    private func setUpConstraints() {
        contentView.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(countryNameLabel)

        cityNameLabel.snp.makeConstraints {
            $0.leadingMargin.trailingMargin.equalToSuperview().inset(8)
            $0.topMargin.equalToSuperview().inset(8)
            $0.height.equalToSuperview().dividedBy(3)
        }

        countryNameLabel.snp.makeConstraints {
            $0.leadingMargin.trailingMargin.equalToSuperview().inset(8)
            $0.bottomMargin.equalToSuperview().inset(8)
            $0.height.equalToSuperview().dividedBy(3)
        }
    }

    func configureLocationNameTVC(model: WeahterSearchResponse?) {
        self.cityNameLabel.text = model?.name
        self.countryNameLabel.text = model?.country
    }
}
