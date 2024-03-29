//
//  LineGraphView.swift
//  Meet
//
//  Created by Derin Dutz on 11/25/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

protocol LineGraphViewDataSource: class {
    func yValueForLineGraphView(xValue: CGFloat) -> CGFloat?
}

class LineGraphView: UIView {
    
    var origin: CGPoint? { didSet { setNeedsDisplay() } }
    
    var color = MeetColor.LightHighlight { didSet { setNeedsDisplay() } }
    
    var color2 = MeetColor.LightestBackground { didSet { setNeedsDisplay() } }
    
    var lineWidth: CGFloat = 1.5 { didSet { setNeedsDisplay() } }
    
    var minYValue: CGFloat = 0 { didSet { setNeedsDisplay() } }
    var maxYValue: CGFloat? { didSet { setNeedsDisplay() } }
    
    var minXValue: CGFloat = 0 { didSet { setNeedsDisplay() } }
    var maxXValue: CGFloat? { didSet { setNeedsDisplay() } }
    
    var graphHeight: CGFloat = 0
    var graphWidth: CGFloat = 0
    
    @IBInspectable
    var scaleX: CGFloat = 50 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var scaleY: CGFloat = 50 { didSet { setNeedsDisplay() } }
    
    weak var dataSource: LineGraphViewDataSource?
    
    override func drawRect(rect: CGRect) {
        if self.origin == nil {
            self.origin = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height - self.lineWidth)
        }
        
        if let maxYVal = self.maxYValue {
            graphHeight = rect.height - rect.origin.y - (self.lineWidth * 2.0)
            self.scaleY = graphHeight / (maxYVal - self.minYValue)
        }
        
        if let maxXVal = self.maxXValue {
            graphWidth = rect.width - rect.origin.x
            self.scaleX = graphWidth / (maxXVal - self.minXValue)
        }
        
        drawGraph()
    }

    private func drawGraph() {
        CGContextSaveGState(UIGraphicsGetCurrentContext())
        color.set()
        let graphPath = UIBezierPath()
        graphPath.lineWidth = self.lineWidth
        
        // Loops over all x values that are currently visible in the view.
        for var drawX = bounds.minX; drawX <= bounds.maxX; ++drawX {
            let xValue = (drawX - origin!.x) / self.scaleX
            
            // Draws a line if the yValue is valid and moves if the last yValue was not valid.
            if let yValue = dataSource?.yValueForLineGraphView(xValue) {
                if yValue.isNormal || yValue.isZero {
                    let drawY = origin!.y - (yValue * self.scaleY)
                    graphPath.addLineToPoint(CGPoint(x: drawX, y: drawY))
                    graphPath.moveToPoint(CGPoint(x: drawX, y: drawY))
                }
            }
        }
        
        graphPath.stroke()
        
        color2.set()
        let yAxis = UIBezierPath()
        let dashes: [CGFloat] = [yAxis.lineWidth * 0, yAxis.lineWidth * 2]
        yAxis.setLineDash(dashes, count: dashes.count, phase: 0)
        yAxis.lineCapStyle = CGLineCap.Round
        yAxis.lineWidth = self.lineWidth
        yAxis.addLineToPoint(CGPoint(x: 0, y: 0))
        yAxis.moveToPoint(CGPoint(x: 0, y: 0))
        yAxis.addLineToPoint(CGPoint(x: graphWidth, y: 0))
        yAxis.moveToPoint(CGPoint(x: graphWidth, y: 0))
        yAxis.stroke()
        
        let max: NSString = Int(self.maxYValue!).description
        max.drawAtPoint(CGPoint(x: 2, y: 0), withAttributes: nil)
        
        let min: NSString = Int(self.minYValue).description
        min.drawAtPoint(CGPoint(x: 2, y: graphHeight - 11), withAttributes: nil)
        
        CGContextRestoreGState(UIGraphicsGetCurrentContext())
    }
}
