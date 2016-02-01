//
//  ResponseTalkingPointCell.swift
//  Meet
//
//  Created by Derin Dutz on 11/23/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class ResponseTalkingPointCell: UITableViewCell {
    
    // MARK: Public API
    
    var talkingPoint: TalkingPoint? {
        didSet {
            updateUI()
        }
    }
    var isRelevant = false {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var talkingPointLabel: UILabel!
    @IBOutlet weak var checkmarkView: UIImageView!
    
    // MARK: GUI
    
    private func updateUI() {
        talkingPointLabel.text = nil
        
        if let talkingPoint = self.talkingPoint {
            talkingPointLabel.text = talkingPoint.text
        }
        
        if self.isRelevant {
            checkmarkView.hidden = false
            let currentFont = talkingPointLabel.font
            let fontName = currentFont.fontName.componentsSeparatedByString("-").first
            let newFont = UIFont(name: "\(fontName!)-Semibold", size: currentFont.pointSize)
            talkingPointLabel.font = newFont
        } else {
            checkmarkView.hidden = true
            let currentFont = talkingPointLabel.font
            let fontName = currentFont.fontName.componentsSeparatedByString("-").first
            let newFont = UIFont(name: "\(fontName!)-Light", size: currentFont.pointSize)
            talkingPointLabel.font = newFont
        }
    }
}
