//
//  HourlyWeatherTableViewCell.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 23.09.2022.
//

import UIKit

class HourlyWeatherTableViewCell: UITableViewCell {
    static let identifier = "HourlyWeatherTableViewCell"

    private var collectionView: UICollectionView!

    private var hourlyModels = [Hourly]()

    override func layoutSubviews() {
        super.layoutSubviews()

        configureCollectionView()
    }

    func configure(with models: [Hourly]) {

        self.hourlyModels = models
        collectionView?.reloadData()
    }

    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height),
            collectionViewLayout: layout)
        collectionView.register(HourlyWeatherCollectionViewCell.self,
                                forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(collectionView)
    }
}

extension HourlyWeatherTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourlyModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourlyWeatherCollectionViewCell.identifier,
            for: indexPath) as? HourlyWeatherCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        cell.configure(with: hourlyModels[indexPath.row])
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 80, height: 80)
    }
}
