//
//  MeetingComposerSummaryTitleCell.swift
//  Meet
//
//  Created by Derin Dutz on 11/16/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetingComposerSummaryTitleCell: UITableViewCell {
    
    // MARK: Public API
    
    var title: String? {
        didSet {
            updateUI()
        }
    }
    
    var time: String? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: GUI
    
    private func updateUI() {
        if let title = self.title {
            titleLabel.text = title
            titleLabel.textColor = MeetColor.DarkHighlight
        } else {
            titleLabel.text = "add meeting name"
            titleLabel.textColor = MeetColor.WarningHighlight
        }
        
        if let time = self.time {
            timeLabel.text = time
            timeLabel.textColor = MeetColor.LightHighlight
        } else {
            let timeErrorStr = NSMutableAttributedString(string: "? min")
            timeErrorStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0, length: 1))
            timeErrorStr.addAttribute(NSForegroundColorAttributeName, value: MeetColor.WarningHighlight, range: NSRange(location: 2, length: 3))
            timeLabel.attributedText = timeErrorStr
        }
    }
}
