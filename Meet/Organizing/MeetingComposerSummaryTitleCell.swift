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
        titleLabel.text = title
        timeLabel.text = time
    }
}
