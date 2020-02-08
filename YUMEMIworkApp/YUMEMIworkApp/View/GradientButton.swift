//
//  GradientButton.swift
//  YUMEMIworkApp
//
//  Created by Daichi Hayashi on 2020/02/06.
//  Copyright © 2020 Daichi Hayashi. All rights reserved.
//

import UIKit

@IBDesignable
class GradientButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var gradientLayer = CAGradientLayer()

    @IBInspectable var startColor: UIColor = .blogBlue {
        didSet {
            setGradient()
        }
    }

    @IBInspectable var endColor: UIColor = .blogPurple {
        didSet {
            setGradient()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            setGradient()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            setGradient()
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0, y: 0.5) {
        didSet {
            setGradient()
        }
    }

    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet {
            setGradient()
        }
    }

    private func setGradient() {

        gradientLayer.removeFromSuperlayer()

        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.frame.size = frame.size
        gradientLayer.frame.origin = CGPoint.init(x: 0.0, y: 0.0)
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.zPosition = -100
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.masksToBounds = true

        imageView?.layer.zPosition = 0

    }

    func setColor(isEnable: Bool) {
        self.isEnabled = isEnable
        if isEnable {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        } else {
            gradientLayer.colors = [UIColor.secondaryLabel, UIColor.secondaryLabel]
        }
    }
}
