//
//  MeetingComposerSummaryAttendeesCell.swift
//  Meet
//
//  Created by Derin Dutz on 11/16/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetingComposerSummaryAttendeesCell: UITableViewCell {
    
    // MARK: Public API
    
    var delegate: MeetingComposerSummaryTableViewController? {
        didSet {
            updateUI()
        }
    }
    
    var attendeeUsernames: [String]? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var attendeeLabel: UILabel!
    @IBOutlet weak var attendeeScrollView: UserScrollView!
    
    // MARK: GUI
    
    private func updateUI() {
        if let attendeeView = attendeeScrollView {
            attendeeView.is_add_enabled = true
            attendeeView.actionDelegate = self.delegate
            if let usernames = attendeeUsernames {
                attendeeView.users = usernames
            }
            attendeeLabel.hidden = true
            return
        }
        
        displayNullState()
    }
    
    private func displayNullState() {
        attendeeLabel.hidden = false
    }
}
