//
//  MeetingComposerSummaryTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/16/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit
import ContactsUI

class MeetingComposerSummaryTableViewController: MeetingComposerTableViewController, CNContactPickerDelegate {
    

    // MARK: Public API
    
    var oldMeeting: Meeting?
    var meeting: Meeting = Meeting() {
        didSet {
            updateUI()
        }
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navcon = self.navigationController as? MeetingComposerNavigationController {
            self.meeting = navcon.meeting
            self.oldMeeting = self.meeting.copy()
        }
        updateUI()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
    }
    
    // MARK: Outlets
    
    @IBAction func cancelComposeMeeting(sender: UIBarButtonItem) {
        if self.meeting == self.oldMeeting {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        let alert = UIAlertController()
        
        let destructiveTitle = self.meeting.status == .New ? "Delete Draft" : "Discard Changes"
        let saveTitle = self.meeting.status == .New ? "Save Draft" : "Save Changes"
        
        alert.addAction(UIAlertAction(
            title: destructiveTitle,
            style: .Destructive)
            { (action: UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        
        alert.addAction(UIAlertAction(
            title: saveTitle,
            style: .Default)
            { (action: UIAlertAction) -> Void in
                self.meeting.saveAsDraft()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .Cancel)
            { (action: UIAlertAction) -> Void in
                // do nothing
            }
        )
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func attendeesAdded(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    
    @IBAction func cancelAddAttendees(segue: UIStoryboardSegue) {
        // Empty.
    }
    
    @IBAction func newTalkingPointComposed(segue: UIStoryboardSegue) {
        updateUI()
    }
    
    @IBAction func cancelComposeTalkingPoint(segue: UIStoryboardSegue) {
        // Empty.
    }
    
    @IBAction func datePicked(segue: UIStoryboardSegue) {
        updateUI()
    }
    
    @IBAction func datePickCancelled(segue: UIStoryboardSegue) {
        // Empty.
    }
    
    // MARK: Storyboard Connectivity
    
    private struct Storyboard {
        static let UnwindNewMeetingComposed = "UnwindNewMeetingComposed"
        static let SegueSetTime = "SegueSetTime"
        static let SegueAddTalkingPoint = "SegueAddTalkingPoint"
        static let MeetingComposerSummaryInformationCellIdentifier = "MeetingComposerSummaryInformationCellIdentifier"
        static let MeetingComposerSummaryAttendeesCellIdentifier = "MeetingComposerSummaryAttendeesCell"
        static let MeetingComposerSummaryNewTalkingPointCellIdentifier = "NewTalkingPointCell"
        static let MeetingComposerSummaryTalkingPointCellIdentifier = "TalkingPointCell"
        static let AttendeePickerNavigationControllerIdentifier = "AttendeePickerNavigationControllerIdentifier"
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.UnwindNewMeetingComposed {
            for talkingPoint in self.meeting.talkingPoints {
                if !talkingPoint.relevantUsers.contains(CurrentUser.username) {
                    talkingPoint.relevantUsers.append(CurrentUser.username)
                }
            }
            if !self.meeting.respondedYes.contains(CurrentUser.username) {
                self.meeting.respondedYes.append(CurrentUser.username)
            }
            return self.meeting.send()
        } else if identifier == Storyboard.SegueAddTalkingPoint {
            return false
        } else if identifier == Storyboard.SegueSetTime {
            return true
        }
        
        return false
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let identifier = segue.identifier {
//            if identifier == Storyboard.UnwindNewMeetingComposed {
//                self.tabBarController?.tabBar.hidden = false
//                self.navigationController?.popViewControllerAnimated(true)
//            }
//        }
////        if let otvc = segue.destinationViewController as? OrganizingTableViewController {
////            if let identifier = segue.identifier {
////                if identifier == Storyboard.UnwindFromNewlyCreatedMeeting {
////                    otvc.meetings[1].append(meeting)
////                }
////            }
////        }
//    }
    
    // MARK: GUI
    
    private func updateUI() {
        tableView.reloadData()
        updateNavigation()
    }
    
    func updateNavigation() {
        self.navigationItem.rightBarButtonItem?.enabled = self.meeting.isReadyToSend()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return meeting.talkingPoints.count
        }
        return 1
    }
    
    var selectedIndex: NSIndexPath? = nil
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectedIndex != nil && selectedIndex == indexPath {
            return 200
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 2:
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? EditableTalkingPointCell {
                self.selectedIndex = indexPath
                cell.isEditingTalkingPoint = true
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        default: break
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryInformationCellIdentifier, forIndexPath: indexPath) as! MeetingComposerSummaryInformationCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.meeting = self.meeting
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryAttendeesCellIdentifier, forIndexPath: indexPath) as! MeetingComposerSummaryAttendeesCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.is_add_enabled = true
            cell.attendeeUsernames = meeting.attendees
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryNewTalkingPointCellIdentifier, forIndexPath: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryTalkingPointCellIdentifier, forIndexPath: indexPath) as! TalkingPointsTableViewCell
            cell.talkingPoint = meeting.talkingPoints[indexPath.row]
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func addUser(sender: UIButton!) {
        let attendeePickerNavCon = self.storyboard?.instantiateViewControllerWithIdentifier(Storyboard.AttendeePickerNavigationControllerIdentifier) as! AttendeePickerNavigationController
        attendeePickerNavCon.attendees = self.meeting.attendees
        self.navigationController?.presentViewController(attendeePickerNavCon, animated: true, completion: nil)
        // TODO: REMOVE
//        let contactPickerViewController = CNContactPickerViewController()
//        contactPickerViewController.delegate = self
//        presentViewController(contactPickerViewController, animated: true, completion: nil)
    }
    
    // MARK: CNContactPicker Delegate
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContacts contacts: [CNContact]) {
        for contact in contacts {
            if let user = AddressBookHelper.getUser(contact) {
                if !self.meeting.attendees.contains(user.username!) {
                    self.meeting.attendees.append(user.username!)
                }
            }
        }
        tableView.reloadData()
    }
}

