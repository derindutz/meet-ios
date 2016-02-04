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
    
    override func viewDidLoad() {
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let currentMinute = calendar.component(.Minute, fromDate: now)
        let remainder = currentMinute % 5
        if remainder != 0 {
            if let date = calendar.dateByAddingUnit(.Minute, value: 5 - remainder, toDate: now, options: NSCalendarOptions()) {
                datePicker.minimumDate = date
            }
        }
    }
    
    // MARK: Storyboard Connectivity
    
    private struct Storyboard {
        static let DatePicked = "Date Picked"
        static let DatePickCancelled = "Date Pick Cancelled"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.DatePicked {
                if let mcstvc = segue.destinationViewController as? MeetingComposerSummaryTableViewController {
                    mcstvc.meeting.startDate = datePicker.date
                }
            }
        }
    }
}

