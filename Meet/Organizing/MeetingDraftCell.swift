//
//  MeetingDraftCell.swift
//  Meet
//
//  Created by Derin Dutz on 11/29/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetingDraftCell: UITableViewCell {
    
    // MARK: Public API
    
    var title: String? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: GUI
    
    private func updateUI() {
        titleLabel.text = nil
        
        if let title = self.title {
            let titleStr = NSMutableAttributedString(string: "\(title) (draft)")
            titleStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0, length: titleStr.length - 8))
            titleStr.addAttribute(NSForegroundColorAttributeName, value: MeetColor.DarkBackground, range: NSRange(location: titleStr.length - 7, length: 7))
            titleLabel.attributedText = titleStr
        } else {
            titleLabel.text = "(draft)"
            titleLabel.textColor = MeetColor.DarkBackground
        }
    }
}
