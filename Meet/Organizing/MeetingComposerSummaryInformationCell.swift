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
    @IBOutlet weak var meetingTimeField: UITextField!
    @IBOutlet weak var meetingDurationField: UITextField!
    @IBOutlet weak var meetingLocationField: UITextField!
    
    // MARK: GUI
    
    private func updateUI() {
        self.meetingNameField.text = self.meeting.title
        self.meetingTimeField.text = DateHelper.getDateEntryString(self.meeting.startDate)
        self.meetingDurationField.text = self.meeting.duration != nil ? "\(self.meeting.duration!)" : nil
        self.meetingLocationField.text = self.meeting.location
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .DateAndTime
        datePicker.addTarget(self, action: "meetingTimeDidChange:", forControlEvents: .ValueChanged)
        self.meetingTimeField.inputView = datePicker
        
        self.meetingNameField.delegate = self
        self.meetingNameField.addTarget(self, action: "meetingNameDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.meetingDurationField.delegate = self
        self.meetingDurationField.addTarget(self, action: "meetingDurationDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.meetingLocationField.delegate = self
        self.meetingLocationField.addTarget(self, action: "meetingLocationDidChange:", forControlEvents: UIControlEvents.EditingChanged)
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
    
    func meetingTimeDidChange(datePicker: UIDatePicker) {
        self.meetingTimeField.text = DateHelper.getDateEntryString(datePicker.date)
        self.meeting.startDate = datePicker.date
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
}
