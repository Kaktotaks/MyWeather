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

    private lazy var locationName: UILabel = {
        let value = UILabel()
        value.font = Constants.Fonts.smallFont
        value.textAlignment = .center
        return value
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        setUpUI()
    }

    private func setUpUI() {
        contentView.addSubview(locationName)
        locationName.snp.makeConstraints {
            $0.centerY.centerX.width.height.equalToSuperview()
        }
    }
}
