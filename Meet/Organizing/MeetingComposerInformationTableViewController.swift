//
//  MeetingComposerInformationTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/16/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetingComposerInformationTableViewController: MeetTableViewController {
    
    // MARK: Public API
    
    var meeting: Meeting = Meeting() {
        didSet {
            updateUI()
        }
    }
    
    var status: String = "Creating"
    
    // MARK: Outlets
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var durationField: UITextField!
    @IBOutlet weak var locationField: UITextField!

    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: remove
        print("meeting \(meeting)")
        
        updateUI()
    }
    
    // MARK: Storyboard Connectivity
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tptvc = segue.destinationViewController as? TalkingPointsTableViewController {
            meeting.title = titleField.text
            if let durationStr = durationField.text {
                meeting.duration = Int(durationStr)
            }
            meeting.location = locationField.text
            tptvc.meeting = meeting
            tptvc.status = status
        }
    }
    
    @IBAction func datePicked(segue: UIStoryboardSegue) {
        // TODO: remove
        print("date picked: \(meeting)")
        updateDate()
    }
    
    @IBAction func datePickCancelled(segue: UIStoryboardSegue) {
        // Empty.
    }
    
    // MARK: GUI
    
    private func updateUI() {
        if let titleField = titleField, durationField = durationField, locationField = locationField {
            if let title = meeting.title {
                titleField.text = title
            }
            
            updateDate()
            
            if let duration = meeting.duration {
                durationField.text = "\(duration)"
            }
            
            if let location = meeting.location {
                locationField.text = location
            }
        }
        print("finished updating")
    }
    
    private func updateDate() {
        if let dateButton = dateButton, startDate = meeting.startDate {
            dateButton.setTitle(DateHelper.getDateEntryString(startDate), forState: .Normal)
            dateButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
    }
}

