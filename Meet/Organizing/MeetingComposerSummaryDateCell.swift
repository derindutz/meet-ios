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
        if let date = self.date {
            dayLabel.text = DateHelper.getDayString(date)
            dayLabel.textColor = UIColor.blackColor()
            monthLabel.text = DateHelper.getThreeLetterMonthString(date)
            monthLabel.textColor = MeetColor.DarkBackground
            startDateLabel.text = DateHelper.getTimeSubtitle(date)
            startDateLabel.textColor = UIColor.blackColor()
        } else {
            dayLabel.text = "?"
            dayLabel.textColor = UIColor.blackColor()
            monthLabel.text = "date"
            monthLabel.textColor = MeetColor.WarningHighlight
            startDateLabel.text = "add time"
            startDateLabel.textColor = MeetColor.WarningHighlight
        }
        
        if let location = self.location {
            locationLabel.text = location
            locationLabel.textColor = UIColor.blackColor()
        } else {
            locationLabel.text = "add location"
            locationLabel.textColor = MeetColor.WarningHighlight
        }
    }
}
