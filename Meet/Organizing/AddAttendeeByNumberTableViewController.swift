//
//  AddAttendeeByNumberTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/17/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class AddAttendeeByNumberTableViewController: MeetTableViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    
    
    // MARK: Storyboard Connectivity
    
    private struct Storyboard {
        static let UnwindFromAddingAttendeeByNumber = "Unwind From Adding Attendee By Number"
        static let CancelAddAttendee = "Cancel Add Attendee"
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.UnwindFromAddingAttendeeByNumber || identifier == Storyboard.CancelAddAttendee {
            return true
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.UnwindFromAddingAttendeeByNumber {
                if let atvc = segue.destinationViewController as? AttendeesTableViewController {
                    let username = numberField.text!
                    
                    if UserDatabase.getUser(username) == nil {
                        let user = User()
                        user.username = username
                        user.fullName = nameField.text!
                        UserDatabase.create(user)
                    }
                    
                    atvc.meeting.attendees.append(username)
                }
            }
        }
    }
}

