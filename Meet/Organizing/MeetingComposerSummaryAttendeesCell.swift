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
    
    @IBOutlet weak var secondAttendeeLabel: UILabel!
    @IBOutlet weak var secondAttendeeImage: UIImageView!
    
    // MARK: GUI
    
    private func updateUI() {
        if let usernames = attendeeUsernames {
            for username in usernames {
                if let user = UserDatabase.getUser(username) {
                    secondAttendeeLabel.text = "\(user.fullName)"
                    return
                }
            }
        }

    }
}
