//
//  ActivityIndicatorManager.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 16.10.2022.
//

import UIKit

class ActivityIndicatorManager: UIView {
    static var shared = ActivityIndicatorManager()

    private var imageView: UIImageView?
    private var loaderImageName = ""

    override func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
//        self.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        imageView?.frame = CGRect(x: self.frame.midX - 20, y: self.frame.midY - 20, width: 60, height: 60)

    }

    func show(with image: String = "loading") {
        loaderImageName = image
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
            if self?.imageView == nil {
                self?.setupView()
                self?.showLoadingActivity()
            }
        }
    }

    func hide() {
        DispatchQueue.main.async {[weak self] in
            self?.stopAnimation()
        }
    }

    private func setupView() {
        let theImage = UIImage(named: loaderImageName)
        imageView = UIImageView(image: theImage)

    }

    private func showLoadingActivity() {
        if let imageView = imageView {
            addSubview(imageView)
            startAnimation()
            UIApplication.shared.windows.first?.addSubview(self)
        }
    }

    private func startAnimation() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
           rotation.toValue = Double.pi * 2
           rotation.duration = 5
           rotation.isCumulative = true
           rotation.repeatCount = Float.greatestFiniteMagnitude
        imageView?.layer.add(rotation, forKey: "rotationAnimation")
    }

    private func stopAnimation() {
        imageView?.removeFromSuperview()
        imageView = nil
        self.removeFromSuperview()
    }
}
