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
        meetingTitleLabel.text = meeting?.title
        meetingSubtitleLabel.text = DateHelper.getTimeSubtitle(meeting?.startDate)
        meetingTimeDayLabel.text = DateHelper.getDayString(meeting?.startDate)
        meetingTimeMonthLabel.text = DateHelper.getThreeLetterMonthString(meeting?.startDate)
    }
}
