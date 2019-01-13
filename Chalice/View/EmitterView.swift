//
//  EmitterView.swift
//  Chalice
//
//  Created by Shaun Anderson on 13/1/19.
//  Copyright © 2019 Shaun Anderson. All rights reserved.
//

import UIKit
import QuartzCore

public class EmitterView: UIView {
    
    var emitter: CAEmitterLayer!
    public var colors: [UIColor]!
    public var intensity: Float!
    public var emitImage: UIImage!
    private var active :Bool!
    
    // Emitter Properties
    public var birthrate: CGFloat = 1
    public var emitterShape = kCAEmitterLayerLine
    // Particle Properties
    public var velocity: CGFloat = 1
    public var velocityScale: CGFloat = 0
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                  UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                  UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                  UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                  UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
        intensity = 0.5
        emitImage = UIImage(named: "Confetti")
        active = false
    }
    
    public func emit() {
        emitter = CAEmitterLayer()
        
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        
        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(confettiWithColor(color: color))
        }
        
        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }
    
    public func stop() {
        emitter?.birthRate = 0
        active = false
    }
    
    
    func confettiWithColor(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 6.0 * intensity
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0
        confetti.color = color.cgColor
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        confetti.emissionLongitude = CGFloat(Double.pi)
        confetti.emissionRange = CGFloat(Double.pi)
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        confetti.contents = emitImage.cgImage
        return confetti
    }
    
    public func isActive() -> Bool {
        return self.active
    }
}
