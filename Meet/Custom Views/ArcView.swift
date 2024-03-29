//
//  ArcView.swift
//  Meet
//
//  Created by Derin Dutz on 11/25/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class ArcView: UIView {
    
    let circleLayer = CAShapeLayer()
    var lineWidth: CGFloat = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(startAngle: CGFloat = -CGFloat(M_PI / 2.0), endAngle: CGFloat = CGFloat(M_PI * (3.0 / 2.0))) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        
        self.backgroundColor = UIColor.clearColor()
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - self.lineWidth)/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer.path = arcPath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = MeetColor.LightHighlight.CGColor
        circleLayer.lineWidth = self.lineWidth;
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        self.layer.addSublayer(circleLayer)
    }
    
    func animateArc(duration: NSTimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.delegate = self
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.addAnimation(animation, forKey: "animateCircle")
    }
    
//    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//        if flag {
//            if let start = startAngle, end = endAngle {
//                if end - start == CGFloat(M_PI * 2.0) {
//                    self.circleLayer.strokeColor = MeetColor.WarningHighlight.CGColor
//                }
//            }
//        }
//    }
    
    private var startAngle: CGFloat?
    private var endAngle: CGFloat?
}
