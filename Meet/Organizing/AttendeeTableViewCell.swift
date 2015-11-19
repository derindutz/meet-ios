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
    
    // MARK: Outlets
    
    @IBOutlet weak var attendeeLabel: UILabel!
    
    // MARK: GUI
    
    private func updateUI() {
        attendeeLabel.text = nil
        
        if let username = self.attendeeUsername, user = UserDatabase.getUser(username) {
            attendeeLabel.text = user.fullName
        }
    }
}


