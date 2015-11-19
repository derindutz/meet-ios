//
//  DatePickerViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/18/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class DatePickerViewController: MeetViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: Storyboard Connectivity
    
    private struct Storyboard {
        static let DatePicked = "Date Picked"
        static let DatePickCancelled = "Date Pick Cancelled"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.DatePicked {
                if let mcitvc = segue.destinationViewController as? MeetingComposerInformationTableViewController {
                    mcitvc.meeting.startDate = datePicker.date
                }
            }
        }
    }
}

