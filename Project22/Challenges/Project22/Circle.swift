//
//  Circle.swift
//  Project22
//
//  Created by Михаил Тихомиров on 14.02.2024.
//

import Foundation
import UIKit


class CircleView: UIView {
    var fillColor: UIColor = .black {
            didSet {
                setNeedsLayout()
            }
        }
    
    var strokeColor:UIColor = .black {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       
        
        // Create a CAShapeLayer
        let circleLayer = CAShapeLayer()
        
        // Define the path for the circle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                      radius: min(bounds.width, bounds.height) / 2,
                                      startAngle: 0,
                                      endAngle: CGFloat.pi * 2,
                                      clockwise: true)
        
        // Assign the path to the layer's path
        circleLayer.path = circlePath.cgPath
        
        // Customize the appearance of the circle
        circleLayer.fillColor = fillColor.cgColor
        circleLayer.strokeColor = strokeColor.cgColor
        circleLayer.lineWidth = 2
        
        
        
        // Add the layer to the view's layer hierarchy
        layer.addSublayer(circleLayer)
    }
}
