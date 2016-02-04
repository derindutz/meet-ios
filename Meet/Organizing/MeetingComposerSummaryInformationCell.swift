//
//  MeetingComposerSummaryInformationCell.swift
//  Meet
//
//  Created by Derin Dutz on 2/3/16.
//  Copyright © 2016 Derin Dutz. All rights reserved.
//

import UIKit

class MeetingComposerSummaryInformationCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: Public API
    
    var delegate: MeetingComposerSummaryTableViewController?
    
    var meeting = Meeting() {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var meetingNameField: UITextField!
    @IBOutlet weak var meetingTimeButton: UIButton!
    @IBOutlet weak var meetingDurationField: UITextField!
    @IBOutlet weak var meetingLocationField: UITextField!
    
    // MARK: GUI
    
    private func updateUI() {
        self.meetingNameField.delegate = self
        self.meetingNameField.addTarget(self, action: "meetingNameDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.meetingDurationField.delegate = self
        self.meetingDurationField.addTarget(self, action: "meetingDurationDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.meetingLocationField.delegate = self
        self.meetingLocationField.addTarget(self, action: "meetingLocationDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        updateDate()
    }
    
    func meetingNameDidChange(textField: UITextField) {
        var text = textField.text
        if text == "" {
            text = nil
        }
        self.meeting.title = text
        if let delegate = self.delegate {
            delegate.updateNavigation()
        }
    }
    
    func meetingDurationDidChange(textField: UITextField) {
        var text = textField.text
        if text == "" {
            text = nil
        }
        if let duration = text {
            self.meeting.duration = Int(duration)
        } else {
            self.meeting.duration = nil
        }
        if let delegate = self.delegate {
            delegate.updateNavigation()
        }
    }
    
    func meetingLocationDidChange(textField: UITextField) {
        var text = textField.text
        if text == "" {
            text = nil
        }
        self.meeting.location = text
        if let delegate = self.delegate {
            delegate.updateNavigation()
        }
    }
    
    private func updateDate() {
        print("updating date...")
        if let timeButton = self.meetingTimeButton, startDate = self.meeting.startDate {
            print("to...\(startDate)")
            timeButton.setTitle(DateHelper.getDateEntryString(startDate), forState: .Normal)
            timeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
    }
}
