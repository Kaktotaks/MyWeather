//
//  ActivityIndicatorManager.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 16.10.2022.
//

import UIKit
import Lottie
import SnapKit

class ActivityIndicatorManager: UIView {
    static var shared = ActivityIndicatorManager()
    private let loadingAnimationView = AnimationView()

    override func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
        setupConstraintsForImage()
    }

    private func setupConstraintsForImage() {
        loadingAnimationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(240)
        }
    }

    func show() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
                self?.setuploadingAnimationView()
        }
    }

    private func setuploadingAnimationView() {
        UIApplication.shared.windows.first?.addSubview(self)
        loadingAnimationView.animation = Animation.named("weatherLoading")
        loadingAnimationView.contentMode = .scaleAspectFit
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.play()
        self.addSubview(loadingAnimationView)
    }

    func hide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
            self?.stopAnimation()
        }
    }

    private func stopAnimation() {
        loadingAnimationView.stop()
        loadingAnimationView.removeFromSuperview()
        self.removeFromSuperview()
    }
}
