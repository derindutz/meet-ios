//
//  AttendeesTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/16/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit
import ContactsUI

class AttendeesTableViewController: MeetingComposerTableViewController, CNContactPickerDelegate {
    
    // MARK: Public API
    
    var meeting: Meeting = Meeting() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Constants
    
    private struct Storyboard {
        static let AttendeeTitleCellIdentifier = "AttendeeTitleCell"
        static let AttendeeCellIdentifier = "AttendeeCell"
        static let NewAttendeeFromContactsCellIdentifier = "NewAttendeeFromContactsCell"
        static let NewAttendeeByNumberCellIdentifier = "NewAttendeeByNumberCell"
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
    }
    
    override func viewWillDisappear(animated: Bool) {
        saveModel()
        return super.viewWillDisappear(animated)
    }
    
    override func saveModel() {
        self.meetingDataSource.meeting.attendees = self.meeting.attendees
    }
    
    @IBAction func newAttendeeAdded(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    
    @IBAction func cancelAddAttendee(segue: UIStoryboardSegue) {
        // Empty.
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return meeting.attendees.count
        default:
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCellWithIdentifier(Storyboard.AttendeeTitleCellIdentifier, forIndexPath: indexPath)
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.AttendeeCellIdentifier, forIndexPath: indexPath) as! AttendeeTableViewCell
            cell.attendeeUsername = meeting.attendees[indexPath.row]
            cell.row = indexPath.row
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.NewAttendeeFromContactsCellIdentifier, forIndexPath: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func removeAttendee(row: Int) {
        self.meeting.attendees.removeAtIndex(row)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 2:
            let contactPickerViewController = CNContactPickerViewController()
            contactPickerViewController.delegate = self
            presentViewController(contactPickerViewController, animated: true, completion: nil)
        default:
            break
        }
    }
    
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
