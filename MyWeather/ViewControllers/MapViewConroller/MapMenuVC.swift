//
//  MapMenuVC.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 24.10.2022.
//

import UIKit
import SnapKit

protocol MapMenuDelegate: AnyObject {
    func choseMapTypeSegment(forItem segment: Int)
}

class MapMenuVC: UIViewController {
    private lazy var mapTypeSegmentedControll: UISegmentedControl = {
        let value = UISegmentedControl(items: mapTypeImages as [Any])
        value.addTarget(self, action: #selector(mapTypeSegmentDidChanged), for: .valueChanged)
        value.backgroundColor = Constants.BackgroundsColors.lightBlue
        value.translatesAutoresizingMaskIntoConstraints = false
        value.selectedSegmentIndex = 0
        value.layer.cornerRadius = 12
        value.layer.masksToBounds = true
        value.contentMode = .scaleAspectFit
        return value
    }()

    private lazy var mapTypeDescriptionLabel: UILabel = {
        let value = UILabel()
        value.contentMode = .left
        value.font = Constants.Fonts.mediumFont
        value.text = "Choose map style"
        return value
    }()

    private let mapTypeImages: [UIImage?] = [UIImage(named: "standartEarth"), UIImage(named: "hybridEearth")]

    weak var delegate: MapMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        setupConstraint()
    }

    @objc func mapTypeSegmentDidChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            delegate?.choseMapTypeSegment(forItem: 0)
        case 1:
            delegate?.choseMapTypeSegment(forItem: 1)
        default:
            delegate?.choseMapTypeSegment(forItem: 0)
        }
    }

    private func setupConstraint() {
        view.addSubview(mapTypeSegmentedControll)
        view.addSubview(mapTypeDescriptionLabel)

        mapTypeSegmentedControll.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(140)
            $0.leading.equalToSuperview().inset(12)
            $0.topMargin.equalToSuperview().inset(40)
        }

        mapTypeDescriptionLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.equalTo(mapTypeSegmentedControll).inset(160)
            $0.centerY.equalTo(mapTypeSegmentedControll)
            $0.rightMargin.equalToSuperview().inset(12)
        }
    }
}
