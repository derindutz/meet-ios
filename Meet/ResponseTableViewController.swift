//
//  ResponseTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/23/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class ResponseTableViewController: MeetTableViewController {
    
    // MARK: Public API
    
    var meeting: Meeting = Meeting() {
        didSet {
            self.selectedPoints = [Bool](count: self.meeting.talkingPoints.count, repeatedValue: false)
            tableView.reloadData()
        }
    }
    
    private var selectedPoints = [Bool]()
    private var isDeclineSelected = true
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let otvc = segue.destinationViewController as? OrganizingTableViewController {
            if let identifier = segue.identifier {
                if identifier == Constants.UnwindFromMeetingResponse {
                    if isDeclineSelected {
                        self.meeting.respondedNo.append(CurrentUser.username)
                        if let indices = otvc.findMeetingIndex(self.meeting) {
                            otvc.meetings[indices.section].removeAtIndex(indices.index)
                        }
                    } else {
                        self.meeting.respondedYes.append(CurrentUser.username)
                        for index in 0..<selectedPoints.count {
                            if selectedPoints[index] {
                                self.meeting.talkingPoints[index].relevantUsers.append(CurrentUser.username)
                            }
                        }
                    }
                    self.meeting.respond()
                }
            }
        }
    }
    
    // MARK: Storyboard Connectivity
    
    private struct Storyboard {
        static let ResponseTitleCellIdentifier = "ResponseTitleCell"
        static let ResponseDateCellIdentifier = "ResponseDateCell"
        static let ResponseTalkingPointsTitleCellIdentifier = "ResponseTalkingPointsTitleCell"
        static let ResponseTalkingPointCellIdentifier = "ResponseTalkingPointCell"
        static let ResponseSubmitCellIdentifier = "ResponseSubmitCell"
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return self.meeting.talkingPoints.count
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ResponseTitleCellIdentifier, forIndexPath: indexPath) as! MeetingComposerSummaryTitleCell
            cell.selectionStyle = .None
            cell.title = meeting.title
            if let duration = meeting.duration {
                cell.time = "\(duration) min"
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ResponseDateCellIdentifier, forIndexPath: indexPath) as! MeetingComposerSummaryDateCell
            cell.selectionStyle = .None
            cell.date = meeting.startDate
            cell.location = meeting.location
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ResponseTalkingPointsTitleCellIdentifier, forIndexPath: indexPath)
            cell.selectionStyle = .None
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ResponseTalkingPointCellIdentifier, forIndexPath: indexPath) as! ResponseTalkingPointCell
            cell.talkingPoint = self.meeting.talkingPoints[indexPath.row]
            cell.isRelevant = self.selectedPoints[indexPath.row]
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ResponseTalkingPointCellIdentifier, forIndexPath: indexPath) as! ResponseTalkingPointCell
            cell.talkingPoint = TalkingPoint(text: Constants.DeclineText)
            cell.isRelevant = self.isDeclineSelected
            return cell
        case 5:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ResponseSubmitCellIdentifier, forIndexPath: indexPath)
            cell.selectionStyle = .None
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 3:
            if self.selectedPoints[indexPath.row] {
                self.selectedPoints[indexPath.row] = false
                if (!self.selectedPoints.contains(true)) {
                    self.isDeclineSelected = true
                }
            } else {
                self.selectedPoints[indexPath.row] = true
                self.isDeclineSelected = false
            }
            tableView.reloadData()
        case 4:
            self.isDeclineSelected = true
            self.selectedPoints = [Bool](count: self.meeting.talkingPoints.count, repeatedValue: false)
            tableView.reloadData()
        default:
            break
        }
    }
    
    // MARK: Constants
    
    private struct Constants {
        static let DeclineText = "none (decline meeting)"
        static let UnwindFromMeetingResponse = "Unwind From Meeting Response"
    }
}
