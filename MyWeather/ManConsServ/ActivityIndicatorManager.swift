//
//  ActivityIndicatorManager.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 16.10.2022.
//

import UIKit

class ActivityIndicatorManager: UIView {
    static var shared = ActivityIndicatorManager()

    private var spinnerBehavior: UIDynamicItemBehavior?
    private var animator: UIDynamicAnimator?
    private var imageView: UIImageView?
    private var loaderImageName = ""

    override func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
//        self.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    }

    func setupView() {
        let theImage = UIImage(named: loaderImageName)
        imageView = UIImageView(image: theImage)
//        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.frame = CGRect(x: self.frame.midX, y: self.frame.midY, width: 60, height: 60)

        if let imageView = imageView {
            self.spinnerBehavior = UIDynamicItemBehavior(items: [imageView])
        }
        animator = UIDynamicAnimator(referenceView: self)
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

    private func showLoadingActivity() {
        if let imageView = imageView {
            addSubview(imageView)
            startAnimation()
            UIApplication.shared.windows.first?.addSubview(self)
        }
    }

    private func startAnimation() {
        guard let imageView = imageView,
              let spinnerBehavior = spinnerBehavior,
              let animator = animator else { return }
        if !animator.behaviors.contains(spinnerBehavior) {
            spinnerBehavior.addAngularVelocity(5.0, for: imageView)
            animator.addBehavior(spinnerBehavior)
        }
    }

    private func stopAnimation() {
        animator?.removeAllBehaviors()
        imageView?.removeFromSuperview()
        imageView = nil
        self.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
