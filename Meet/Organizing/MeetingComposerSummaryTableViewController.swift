//
//  MeetingComposerSummaryTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/16/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetingComposerSummaryTableViewController: MeetingComposerTableViewController {

    // MARK: Public API
    
    var meeting: Meeting = Meeting() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
    }
    
//    override func viewWillAppear(animated: Bool) {
//        self.meeting = self.meetingDataSource.meeting
//        return super.viewWillAppear(animated)
//    }
    
    // MARK: Storyboard Connectivity
    
    @IBOutlet weak var meetingNameField: UITextField!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var durationField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    
    private struct Storyboard {
        static let UnwindFromNewlyCreatedMeeting = "Unwind From Newly Created Meeting"
        static let MeetingComposerSummaryTitleCellIdentifier = "MeetingComposerSummaryTitleCell"
        static let MeetingComposerSummaryDateCellIdentifier = "MeetingComposerSummaryDateCell"
        static let MeetingComposerSummaryAttendeesCellIdentifier = "MeetingComposerSummaryAttendeesCell"
        static let MeetingComposerSummaryTalkingPointsTitleCellIdentifier = "MeetingComposerSummaryTalkingPointsTitleCell"
        static let MeetingComposerSummaryTalkingPointCellIdentifier = "MeetingComposerSummaryTalkingPointCell"
        static let MeetingComposerSummaryTalkingPointErrorCellIdentifier = "MeetingComposerSummaryTalkingPointErrorCell"
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.UnwindFromNewlyCreatedMeeting {
            for talkingPoint in self.meeting.talkingPoints {
                if !talkingPoint.relevantUsers.contains(CurrentUser.username) {
                    talkingPoint.relevantUsers.append(CurrentUser.username)
                }
            }
            if !self.meeting.respondedYes.contains(CurrentUser.username) {
                self.meeting.respondedYes.append(CurrentUser.username)
            }
            return self.meeting.send()
        }
        
        return false
    }
    
    @IBAction func sendMeeting(sender: UIBarButtonItem) {
        print("sent")
    }
    
    
    @IBAction func cancelComposeMeeting(sender: UIBarButtonItem) {
        let alert = UIAlertController()
        
        alert.addAction(UIAlertAction(
            title: "Delete Draft",
            style: .Destructive)
            { (action: UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        
        alert.addAction(UIAlertAction(
            title: "Save Draft",
            style: .Default)
            { (action: UIAlertAction) -> Void in
                self.meeting.save()
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
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.UnwindFromNewlyCreatedMeeting {
                self.tabBarController?.tabBar.hidden = false
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
//        if let otvc = segue.destinationViewController as? OrganizingTableViewController {
//            if let identifier = segue.identifier {
//                if identifier == Storyboard.UnwindFromNewlyCreatedMeeting {
//                    otvc.meetings[1].append(meeting)
//                }
//            }
//        }
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            if meeting.talkingPoints.isEmpty {
                return 1
            }
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
            if meeting.talkingPoints.isEmpty {
                return tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryTalkingPointErrorCellIdentifier, forIndexPath: indexPath)
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MeetingComposerSummaryTalkingPointCellIdentifier, forIndexPath: indexPath) as! MeetingComposerSummaryTalkingPointCell
            cell.talkingPoint = meeting.talkingPoints[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
}

