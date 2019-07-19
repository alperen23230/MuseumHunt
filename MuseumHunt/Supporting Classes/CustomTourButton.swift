//
//  CustomTourButton.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 18.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import UIKit
import ChameleonFramework

class CustomTourButton: UIButton{
    
    var pulsatingLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton(){
        setPulsating()
        setShadow()
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = UIColor.flatMagenta()
        titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 20)
        layer.cornerRadius = 50
        layer.borderWidth = 0.0
        layer.borderColor = UIColor(hexString: "#753B8F")?.cgColor
    }
    
    private func setShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    private func setPulsating(){
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 50, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = 10
        pulsatingLayer.fillColor = UIColor.flatMagenta()?.cgColor
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        pulsatingLayer.position.x = 50
        pulsatingLayer.position.y = 50
        layer.addSublayer(pulsatingLayer)
    }
    func animatePulsatingLayer(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.5
        animation.duration = 0.6
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    func stopAnimating(){
        pulsatingLayer.removeAllAnimations()
    }
    
}
