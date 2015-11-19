//
//  AttendeesTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/16/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class AttendeesTableViewController: MeetTableViewController {
    
    // MARK: Public API
    
    var meeting: Meeting = Meeting() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var status: String = "Creating"
    
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
    
    @IBAction func newAttendeeAdded(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    
    @IBAction func cancelAddAttendee(segue: UIStoryboardSegue) {
        // Empty.
    }
    
    // MARK: Storyboard Connectivity
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mcstvc = segue.destinationViewController as? MeetingComposerSummaryTableViewController {
            mcstvc.meeting = meeting
            mcstvc.status = status
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
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
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.NewAttendeeFromContactsCellIdentifier, forIndexPath: indexPath)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.NewAttendeeByNumberCellIdentifier, forIndexPath: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
