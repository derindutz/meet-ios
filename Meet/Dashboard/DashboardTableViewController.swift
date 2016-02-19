//
//  DashboardTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/22/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class DashboardTableViewController: MeetTableViewController {
    
    private var nextMeeting: Meeting? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTabs()
        
        self.nextMeeting = MeetingDatabase.getNextMeeting()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 386
    }
    
    private func updateTabs() {
        if let tabItem = self.tabBarController?.tabBar.items?[1] {
            MeetingDatabase.badgeTabItem = tabItem
            MeetingDatabase.isAwaitingResponse = MeetingDatabase.isAwaitingResponse
        }
    }
    
    // TODO: fix having to load twice
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.nextMeeting = MeetingDatabase.getNextMeeting()
    }
    
    // MARK: Storyboard Connectivity
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mstvc = segue.destinationViewController as? MeetingSummaryTableViewController {
            if let identifier = segue.identifier {
                if identifier == Constants.SegueShowMeetingSummary {
                    navigationItem.backBarButtonItem = nil
                    
                    mstvc.meeting = nextMeeting!
                }
            }
        } else if let cmvc = segue.destinationViewController as? ComposeMeetingViewController {
            if let identifier = segue.identifier {
                if identifier == Constants.SegueCreateMeeting {
                    let backItem = UIBarButtonItem()
                    backItem.title = ""
                    navigationItem.backBarButtonItem = backItem
                    
                    let newMeeting = Meeting()
                    newMeeting.createInDatabase()
                    cmvc.meeting = newMeeting
                }
            }
        }
    }

    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // TODO: fix case where no next meeting
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.DashboardStatisticsCellIdentifier, forIndexPath: indexPath) as! DashboardStatisticsTableViewCell
            cell.update()
            cell.selectionStyle = .None
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.NextMeetingTitleCellIdentifier, forIndexPath: indexPath) as! MeetingComposerSummaryTitleCell
            cell.selectionStyle = .None
            cell.title = Constants.NextMeetingTitleCellTitle
            if let nextMeeting = self.nextMeeting {
                cell.time = DateHelper.getTimeUntilMeeting(nextMeeting)
            } else {
                cell.time = ""
            }
            return cell
        case 2:
            if let meeting = self.nextMeeting {
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.NextMeetingCellIdentifier, forIndexPath: indexPath) as! MeetingTableViewCell
                cell.meeting = meeting
                return cell
            } else {
                return tableView.dequeueReusableCellWithIdentifier(Constants.MeetingSectionNullStateCellIdentifier, forIndexPath: indexPath)
            }
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: Constants
    
    private struct Constants {
        static let DashboardStatisticsCellIdentifier = "DashboardStatisticsCell"
        static let NextMeetingTitleCellIdentifier = "NextMeetingTitleCell"
        static let NextMeetingTitleCellTitle = "Next Meeting"
        static let NextMeetingCellIdentifier = "NextMeetingCell"
        static let MeetingSectionNullStateCellIdentifier = "MeetingSectionNullStateCell"
        static let SegueShowMeetingSummary = "Segue Show Meeting Summary From Dashboard"
        static let SegueCreateMeeting = "Segue Create Meeting From Dashboard"
    }
}

