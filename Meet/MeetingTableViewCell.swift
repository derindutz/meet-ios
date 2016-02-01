//
//  MeetingTableViewCell.swift
//  Meet
//
//  Created by Derin Dutz on 11/15/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetingTableViewCell: UITableViewCell {
    
    // MARK: Public API
    
    var meeting: Meeting? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var meetingTitleLabel: UILabel!
    @IBOutlet weak var meetingSubtitleLabel: UILabel!
    @IBOutlet weak var meetingTimeDayLabel: UILabel!
    @IBOutlet weak var meetingTimeMonthLabel: UILabel!
    
    // MARK: GUI
    
    private func updateUI() {
        if let titleString = meeting?.title {
            meetingTitleLabel.text = titleString
            meetingTitleLabel.textColor = UIColor.blackColor()
        } else {
            meetingTitleLabel.text = "add meeting name"
            meetingTitleLabel.textColor = MeetColor.WarningHighlight
        }
        
        if let timeString = DateHelper.getTimeSubtitle(meeting?.startDate) {
            if self.meeting?.host == CurrentUser.username {
                let subtitleStr = NSMutableAttributedString(string: "\(timeString) (hosting)")
                subtitleStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0, length: subtitleStr.length - 10))
                subtitleStr.addAttribute(NSForegroundColorAttributeName, value: MeetColor.DarkBackground, range: NSRange(location: subtitleStr.length - 9, length: 9))
                meetingSubtitleLabel.attributedText = subtitleStr
            } else {
                meetingSubtitleLabel.text = timeString
                meetingSubtitleLabel.textColor = UIColor.blackColor()
            }
        } else {
            meetingSubtitleLabel.text = "add time"
            meetingSubtitleLabel.textColor = MeetColor.WarningHighlight
        }
        
        if let dayString = DateHelper.getDayString(meeting?.startDate) {
            meetingTimeDayLabel.text = dayString
        } else {
            meetingTimeDayLabel.text = "?"
        }
    
        if let monthString = DateHelper.getThreeLetterMonthString(meeting?.startDate) {
            meetingTimeMonthLabel.text = monthString
            meetingTimeMonthLabel.textColor = MeetColor.DarkBackground
        } else {
            meetingTimeMonthLabel.text = "date"
            meetingTimeMonthLabel.textColor = MeetColor.WarningHighlight
        }
        
    }
}
