//
//  LabelAboveViewView.swift
//  Meet
//
//  Created by Derin Dutz on 12/2/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class LabelAboveViewView: UIView {
    
    // MARK: Public API
    
    var topLabel: UILabel? {
        didSet {
            updateUI()
        }
    }
    
    var bottomView: UIView? {
        didSet {
            updateUI()
        }
    }
    
    var horizontalSeparation: CGFloat = 5
    
    // MARK: GUI
    
    private func updateUI() {
        self.prevTopLabel?.removeFromSuperview()
        self.prevBottomView?.removeFromSuperview()
        
        var selfHeight: CGFloat = 0
        
        if let topLabel = self.topLabel {
            let labelY: CGFloat = 0
            let labelHeight = topLabel.frame.height
            let labelFrame = CGRectMake(0, 0, topLabel.frame.width, labelHeight)
            topLabel.frame = labelFrame
            self.addSubview(topLabel)
            self.prevTopLabel = topLabel
            
            selfHeight = labelY + labelHeight
        }
        
        if let bottomView = self.bottomView {
            
            var viewY: CGFloat = 0
            if let topLabel = prevTopLabel {
                viewY = topLabel.frame.height + self.horizontalSeparation
            }
            
            let viewFrame = CGRectMake(0, viewY, bottomView.frame.width, bottomView.frame.height)
            bottomView.frame = viewFrame
            self.addSubview(bottomView)
            self.prevBottomView = bottomView
            
            selfHeight = viewY + bottomView.frame.height
        }
        
        self.frame = CGRectMake(self.frame.minX, self.frame.minY, self.frame.width, selfHeight)
    }
    
    // MARK: Private Instance Variables
    
    private var prevTopLabel: UILabel?
    private var prevBottomView: UIView?
}
