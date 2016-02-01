//
//  MeetingSummaryTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/22/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetingSummaryTableViewController: MeetTableViewController {
    
    // MARK: Public API
    
    var meeting: Meeting = Meeting() {
        didSet {
            updateUI()
            tableView.reloadData()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func updateUI() {
        if self.meeting.host == CurrentUser.username {
            self.navigationItem.rightBarButtonItem = self.editBarButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    // MARK: Storyboard Connectivity
    
    private struct Storyboard {
        static let SegueEditMeetingFromSummary = "Segue Edit Meeting From Summary"
        static let MeetingComposerSummaryTitleCellIdentifier = "MeetingComposerSummaryTitleCell"
        static let MeetingComposerSummaryDateCellIdentifier = "MeetingComposerSummaryDateCell"
        static let MeetingComposerSummaryAttendeesCellIdentifier = "MeetingComposerSummaryAttendeesCell"
        static let MeetingComposerSummaryTalkingPointsTitleCellIdentifier = "MeetingComposerSummaryTalkingPointsTitleCell"
        static let TalkingPointWithProfilesCellIdentifier = "TalkingPointWithProfilesCell"
        static let CancelMeetingCellIdentifier = "CancelMeetingCell"
        static let UnwindCancelMeeting = "Cancel Meeting"
        static let ShowTalkingPointSummary = "ShowTalkingPointSummary"
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.UnwindCancelMeeting {
            self.navigationController?.popViewControllerAnimated(true)
            return self.meeting.cancel()
        } else if identifier == Storyboard.SegueEditMeetingFromSummary || identifier == Storyboard.ShowTalkingPointSummary {
            return true
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cmvc = segue.destinationViewController as? ComposeMeetingViewController {
            if let identifier = segue.identifier {
                if identifier == Storyboard.SegueEditMeetingFromSummary {
                    cmvc.meeting = self.meeting.copy()
                }
            }
        } else if let tpstvc = segue.destinationViewController as? TalkingPointSummaryTableViewController {
            if let senderCell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(senderCell) {
                print("section \(indexPath.section) row: \(indexPath.row)")
                tpstvc.talkingPoint = self.meeting.talkingPoints[indexPath.row]
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.meeting.host == CurrentUser.username {
            return 6
        }
        
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
            cell.selectionStyle = .None
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryDateCellIdentifier, forIndexPath: indexPath) as! MeetingComposerSummaryDateCell
            cell.date = meeting.startDate
            cell.location = meeting.location
            cell.selectionStyle = .None
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryAttendeesCellIdentifier, forIndexPath: indexPath) as! MeetingComposerSummaryAttendeesCell
            cell.attendeeUsernames = meeting.respondedYes
            cell.selectionStyle = .None
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryTalkingPointsTitleCellIdentifier, forIndexPath: indexPath)
            cell.selectionStyle = .None
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TalkingPointWithProfilesCellIdentifier, forIndexPath: indexPath) as! TalkingPointWithProfilesCell
            cell.talkingPoint = meeting.talkingPoints[indexPath.row]
            return cell
        case 5:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CancelMeetingCellIdentifier, forIndexPath: indexPath)
            cell.selectionStyle = .None
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    private func heightForTalkingPoint(talkingPoint: TalkingPoint) -> CGFloat {
        return TalkingPointWithProfilesCell.getHeight(talkingPoint)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return heightForTalkingPoint(self.meeting.talkingPoints[indexPath.row])
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
}
