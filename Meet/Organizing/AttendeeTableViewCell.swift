//
//  AttendeeTableViewCell.swift
//  Meet
//
//  Created by Derin Dutz on 11/16/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class AttendeeTableViewCell: UITableViewCell {
    
    // MARK: Public API
    
    var attendeeUsername: String? {
        didSet {
            updateUI()
        }
    }
    
    var row: Int?
    var delegate: AttendeesTableViewController?
    
    // MARK: Outlets
    
    @IBOutlet weak var attendeeLabel: UILabel!
    
    @IBOutlet weak var removeAttendeeButton: UIButton!
    
    @IBAction func removeAttendee(sender: UIButton) {
        if let delegate = self.delegate, row = self.row {
            delegate.removeAttendee(row)
        }
    }
    
    // MARK: GUI
    
    private func updateUI() {
        attendeeLabel.text = nil
        
        if let username = self.attendeeUsername {
            if let removeButton = removeAttendeeButton {
                if username == CurrentUser.username {
                    removeButton.hidden = true
                } else {
                    removeButton.hidden = false
                }
            }
            
            if let user = UserDatabase.getUser(username) {
                attendeeLabel.text = user.fullName
            }
        }
    }
}


