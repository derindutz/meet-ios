//
//  MeetingComposerSummaryDateCell.swift
//  Meet
//
//  Created by Derin Dutz on 11/16/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetingComposerSummaryDateCell: UITableViewCell {
    
    // MARK: Public API
    
    var date: NSDate? {
        didSet {
            updateUI()
        }
    }
    
    var location: String? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    // MARK: GUI
    
    private func updateUI() {
        dayLabel.text = DateHelper.getDayString(date)
        monthLabel.text = DateHelper.getThreeLetterMonthString(date)
        startDateLabel.text = DateHelper.getTimeSubtitle(date)
        locationLabel.text = location
    }
}
