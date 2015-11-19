//
//  OrganizingTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/15/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class OrganizingTableViewController: MeetTableViewController {
    
    // MARK: Public API
    
    var meetings: [[Meeting]] = [[Meeting]]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Constants
    
    private struct Section {
        static let Unsent = "unsent"
        static let Hosting = "hosting"
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meetings = MeetingDatabase.getOrganizingMeetings()
        print(meetings)
    }
    
    @IBAction func newMeetingComposed(segue: UIStoryboardSegue) {
        print("new meeting composed")
    }
    
    // MARK: Storyboard Connectivity
    
    private struct Storyboard {
        static let SegueEditMeeting = "Segue Edit Meeting"
        static let CellReuseIdentifier = "MeetingCell"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mcitvc = segue.destinationViewController as? MeetingComposerInformationTableViewController {
            if let identifier = segue.identifier {
                if identifier == Storyboard.SegueEditMeeting {
                    if let cell = sender as? MeetingTableViewCell {
                        if let indexPath = tableView?.indexPathForCell(cell) {
                            mcitvc.meeting = meetings[indexPath.section][indexPath.row]
                            mcitvc.status = "Editing"
                        }
                    }
                }
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return meetings.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if meetings[0].isEmpty {
               return nil
            }
            return Section.Unsent
        case 1:
            if meetings[1].isEmpty {
                return nil
            }
            return Section.Hosting
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! MeetingTableViewCell
        cell.meeting = meetings[indexPath.section][indexPath.row]
        return cell
    }
}
