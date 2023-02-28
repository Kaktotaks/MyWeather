//
//  ActivityIndicatorManager.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 16.10.2022.
//

import UIKit
import Lottie
import SnapKit

class AnimatedViewManager: UIView {
    static var shared = AnimatedViewManager()

    private let loadingAnimationView = AnimationView()

    private let okButton: UIButton = {
        let value = UIButton()
        value.setTitle("OK", for: .normal)
        value.clipsToBounds = true
        value.layer.cornerRadius = 14
        value.backgroundColor = Constants.BackgroundsColors.lightBlue
        value.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        value.layer.shadowOffset = CGSize(width: 0, height: 3)
        value.layer.shadowOpacity = 1.5
        value.layer.shadowRadius = 2
        value.layer.masksToBounds = false
        return value
    }()

    private let descriptionLabel: UILabel = {
        let value = UILabel()
        value.font = Constants.Fonts.mediumFont
        value.numberOfLines = 0
        value.textAlignment = .center
        return value
    }()

    enum AnimationName: String {
        case weatherLoading, tapAndHold
    }

    // MARK: - Setup UI Components
    override func layoutSubviews() {
        super.layoutSubviews()

        setupView()
        setupAnimationView()
    }

    private func setupView() {
        self.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
    }

    private func setupAnimationView() {
        self.addSubview(self.loadingAnimationView)
        loadingAnimationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(240)
        }
    }

    private func setupConstraintsForInfo() {
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.okButton)

        self.descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(loadingAnimationView).offset(-50)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(70)
        }

        self.okButton.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
    }

    // MARK: - Methods
    func showIndicator(_ animationName: AnimationName) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }

            UIApplication.shared.windows.first?.addSubview(self)
            self.loadingAnimationView.animation = Animation.named(animationName.rawValue)
            self.loadingAnimationView.contentMode = .scaleAspectFit
            self.loadingAnimationView.loopMode = .loop
            self.loadingAnimationView.play()
            self.addSubview(self.loadingAnimationView)
        }
    }

    func showInfoAnimation(_ animationName: AnimationName, descriptionText: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }

            UIApplication.shared.windows.first?.addSubview(self)
            self.loadingAnimationView.animation = Animation.named(animationName.rawValue)
            self.loadingAnimationView.contentMode = .scaleAspectFit
            self.loadingAnimationView.loopMode = .loop
            self.loadingAnimationView.play()
            self.descriptionLabel.text = descriptionText

            self.setupAnimationView()
            self.setupConstraintsForInfo()
        }
    }

    func hide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
            self?.stopAnimation()
        }
    }

    @objc func okButtonTapped() {
        DispatchQueue.main.async {[weak self] in
            self?.stopAnimation()
        }
    }

    private func stopAnimation() {
        loadingAnimationView.stop()
        loadingAnimationView.removeFromSuperview()
        descriptionLabel.removeFromSuperview()
        okButton.removeFromSuperview()
        self.removeFromSuperview()
    }
}
