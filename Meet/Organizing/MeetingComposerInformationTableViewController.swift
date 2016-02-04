//
//  MeetingComposerInformationTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/16/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetingComposerInformationTableViewController: MeetingComposerTableViewController, UITextFieldDelegate {
    
    // MARK: Public API
    
    var meeting: Meeting = Meeting() {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var durationField: UITextField!
    @IBOutlet weak var locationField: UITextField!

    @IBOutlet weak var fakePageControl: UIPageControl!
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        titleField.delegate = self
        durationField.delegate = self
        locationField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fakePageControl.hidden = true
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterFromKeyboardNotifications()
        saveModel()
    }
    
    override func saveModel() {
        updateMeetingData(self.meeting)
        updateMeetingData(self.meetingDataSource.meeting)
    }
    
    // MARK: Storyboard Connectivity
    
    private func updateMeetingData(meeting: Meeting) {
        meeting.title = getText(titleField)
        if let durationText = getText(durationField) {
            meeting.duration = Int(durationText)
        } else {
            meeting.duration = nil
        }
        meeting.location = getText(locationField)
    }
    
    private func getText(textField: UITextField) -> String? {
        if let text = textField.text {
            if !text.isEmpty {
                return text
            }
        }
        return nil
    }
    
    @IBAction func datePicked(segue: UIStoryboardSegue) {
        updateDate()
    }
    
    @IBAction func datePickCancelled(segue: UIStoryboardSegue) {
        // Empty.
    }
    
    // TODO: make keyboard disappear when hit return
    
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
    }
    
    // TODO: fix bug where date not updated
    // TODO: date in 15 minute increments and don't allow past dates
    
    private func updateDate() {
        print("updating date...")
        if let dateButton = dateButton, startDate = meeting.startDate {
            print("to...\(startDate)")
            dateButton.setTitle(DateHelper.getDateEntryString(startDate), forState: .Normal)
            dateButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
    }
    
    // MARK: Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        fakePageControl.hidden = true
        self.view.endEditing(true)
        return false
    }
    
    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications() {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        fakePageControl.hidden = false
    }
    
    
    func keyboardWillBeHidden(notification: NSNotification) {
        fakePageControl.hidden = true
        self.view.endEditing(true)
    }

}

