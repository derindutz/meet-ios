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
        if let usernames = attendeeUsernames {
            if usernames.count > 0 {
                if let attendeeView = attendeeScrollView {
                    attendeeView.users = usernames
                    attendeeLabel.hidden = true
                    return
                }
            }
        }
        
        displayNullState()
    }
    
    private func displayNullState() {
        attendeeLabel.hidden = false
    }
}
