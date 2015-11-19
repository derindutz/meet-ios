//
//  MeetingComposerSummaryTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/16/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetingComposerSummaryTableViewController: MeetTableViewController {

    // MARK: Public API
    
    var meeting: Meeting = Meeting() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var status: String = "Creating"
    
    // MARK: Storyboard Connectivity
    
    private struct Storyboard {
        static let UnwindFromNewlyCreatedMeeting = "Unwind From Newly Created Meeting"
        static let MeetingComposerSummaryTitleCellIdentifier = "MeetingComposerSummaryTitleCell"
        static let MeetingComposerSummaryDateCellIdentifier = "MeetingComposerSummaryDateCell"
        static let MeetingComposerSummaryAttendeesCellIdentifier = "MeetingComposerSummaryAttendeesCell"
        static let MeetingComposerSummaryTalkingPointsTitleCellIdentifier = "MeetingComposerSummaryTalkingPointsTitleCell"
        static let MeetingComposerSummaryTalkingPointCellIdentifier = "MeetingComposerSummaryTalkingPointCell"
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.UnwindFromNewlyCreatedMeeting {
            return finishComposingMeeting()
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let otvc = segue.destinationViewController as? OrganizingTableViewController {
            switch status {
            case "Creating":
                otvc.meetings[1].append(meeting)
            case "Editing":
                if let indices = findMeetingIndex(meeting, meetingsArr: otvc.meetings) {
                    otvc.meetings[indices.section][indices.index] = meeting
                }
            default:
                print("invalid status")
            }
        }
    }
    
    private func findMeetingIndex(meeting: Meeting, meetingsArr: [[Meeting]]) -> (section: Int, index: Int)? {
        for (section, meetings) in meetingsArr.enumerate() {
            for (index, existingMeeting) in meetings.enumerate() {
                if existingMeeting.id == meeting.id {
                    return (section, index)
                }
            }
        }
        
        return nil
    }
    
    // MARK: Meeting Creation
    
    private func finishComposingMeeting() -> Bool {
        switch status {
        case "Creating":
            MeetingDatabase.create(meeting)
        case "Editing":
            MeetingDatabase.update(meeting)
        default:
            print("invalid status")
        }
        
        return true
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return meeting.talkingPoints.count
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryTitleCellIdentifier, forIndexPath: indexPath) as! MeetingComposerSummaryTitleCell
            cell.title = meeting.title
            if let duration = meeting.duration {
                cell.time = "\(duration) min"
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryDateCellIdentifier, forIndexPath: indexPath) as! MeetingComposerSummaryDateCell
            cell.date = meeting.startDate
            cell.location = meeting.location
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryAttendeesCellIdentifier, forIndexPath: indexPath) as! MeetingComposerSummaryAttendeesCell
            cell.attendeeUsernames = meeting.attendees
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryTalkingPointsTitleCellIdentifier, forIndexPath: indexPath)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryTalkingPointCellIdentifier, forIndexPath: indexPath) as! MeetingComposerSummaryTalkingPointCell
            cell.talkingPoint = meeting.talkingPoints[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
}

