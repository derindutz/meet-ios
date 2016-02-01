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
    
    private func updateTabs() {
        if let tabItem = self.tabBarController?.tabBar.items?[1] {
            MeetingDatabase.badgeTabItem = tabItem
            MeetingDatabase.isAwaitingResponse = MeetingDatabase.isAwaitingResponse
        }
    }
    
    func findMeetingIndex(meeting: Meeting) -> (section: Int, index: Int)? {
        for (section, meetings) in self.meetings.enumerate() {
            for (index, existingMeeting) in meetings.enumerate() {
                if existingMeeting.id == meeting.id {
                    return (section, index)
                }
            }
        }
        return nil
    }
    
    private var headers: [String] = [String]()
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTabs()
        getMode()
        setupHeaders()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
    }
    
    private func getMode() {
        if let currentTab = self.tabBarController?.selectedIndex {
            switch currentTab {
            case 1:
                self.mode = .Upcoming
            case 2:
                self.mode = .Organizing
            default:
                print("invalid tab")
            }
        }
    }
    
    private func setupHeaders() {
        switch self.mode {
        case .Upcoming:
            headers = [Constants.AwaitingResponseSection, Constants.UpcomingSection]
        case .Organizing:
            headers = [Constants.UnsentSection, Constants.HostingSection]
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupMeetings()
    }
    
    private func setupMeetings() {
        if let currentTab = self.tabBarController?.selectedIndex {
            switch currentTab {
            case 1:
                meetings = MeetingDatabase.getUpcomingMeetings()
            case 2:
                meetings = MeetingDatabase.getOrganizingMeetings()
            default:
                print("invalid tab")
            }
        }
    }
    
    @IBAction func newMeetingComposed(segue: UIStoryboardSegue) {
        setupMeetings()
    }
    
    @IBAction func saveMeeting(segue: UIStoryboardSegue) {
        setupMeetings()
    }
    
    @IBAction func cancelMeeting(segue: UIStoryboardSegue) {
        print("meeting cancelled")
    }
    
    @IBAction func responseSent(segue: UIStoryboardSegue) {
        // TODO: remove
        print("response sent")
        print(self.meetings)
        tableView.reloadData()
    }
    
    // MARK: Storyboard Connectivity
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isLargeSeparator(indexPath) || isNullStateCell(indexPath) {
            return
        }
        
        let selectedMeeting = meetings[indexPath.section][indexPath.row]
        if selectedMeeting.status == .Unsent {
            let composeMeetingVC = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.MeetingComposerVCIdentifier) as! ComposeMeetingViewController
            composeMeetingVC.meeting = selectedMeeting.copy()
            setBackButtonLabelEmpty()
            self.navigationController?.pushViewController(composeMeetingVC, animated: true)
        } else {
            if selectedMeeting.respondedYes.contains(CurrentUser.username) {
                let meetingSummaryVC = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.MeetingSummaryVCIdentifier) as! MeetingSummaryTableViewController
                meetingSummaryVC.meeting = selectedMeeting
                setBackButtonDefault()
                self.navigationController?.pushViewController(meetingSummaryVC, animated: true)
            } else {
                let meetingResponseVC = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.MeetingResponseVCIdentifier) as! ResponseTableViewController
                meetingResponseVC.meeting = selectedMeeting
                setBackButtonDefault()
                self.navigationController?.pushViewController(meetingResponseVC, animated: true)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cmvc = segue.destinationViewController as? ComposeMeetingViewController {
            if let identifier = segue.identifier {
                if identifier == Constants.SegueCreateMeeting {
                    setBackButtonLabelEmpty()
                    
                    let newMeeting = Meeting()
                    newMeeting.createInDatabase()
                    cmvc.meeting = newMeeting
                } else if identifier == Constants.SegueEditMeeting {
                    if let cell = sender as? MeetingTableViewCell {
                        if let indexPath = tableView?.indexPathForCell(cell) {
                            setBackButtonLabelEmpty()
                            
                            let meeting = meetings[indexPath.section][indexPath.row]
                            cmvc.meeting = meeting.copy()
                        }
                    }
                }
            }
        }
    }
    
    private func setBackButtonDefault() {
        print("setting back button label default")
        navigationItem.backBarButtonItem = nil
    }
    
    private func setBackButtonLabelEmpty() {
        print("setting back button label empty")
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return meetings.count
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 && meetings[section].isEmpty {
            return nil
        }
        let headerCell = tableView.dequeueReusableCellWithIdentifier(Constants.HeaderCellIdentifier) as! MeetTableViewHeaderCell
        headerCell.title = headers[section]
        headerCell.contentView.backgroundColor = UIColor.whiteColor()
        return headerCell.contentView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 && meetings[section].isEmpty {
            return 0
        }
        let headerCell = tableView.dequeueReusableCellWithIdentifier(Constants.HeaderCellIdentifier) as! MeetTableViewHeaderCell
        headerCell.title = headers[section]
        return headerCell.frame.height
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            let cellCount = meetings[0].isEmpty ? 1 : meetings[0].count
            let separatorCount = meetings[1].isEmpty ? 0 : 1
            return cellCount + separatorCount
        default:
            return meetings[section].count
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isLargeSeparator(indexPath) {
            return 16
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    private func isLargeSeparator(indexPath: NSIndexPath) -> Bool {
        return indexPath.section == 0
            && !meetings.isEmpty
            && !meetings[1].isEmpty
            && ((meetings[0].count <= 0 && indexPath.row == 1)
                || (meetings[0].count > 0 && indexPath.row >= meetings[0].count))
    }
    
    private func isNullStateCell(indexPath: NSIndexPath) -> Bool {
        return indexPath.section == 0
            && meetings[0].count <= 0
            && indexPath.row == 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if isLargeSeparator(indexPath) {
                let largeSeparator = UITableViewCell()
                largeSeparator.selectionStyle = .None
                largeSeparator.backgroundColor = MeetColor.LightestBackground
                return largeSeparator
            }
            
            if meetings[indexPath.section].count <= 0 {
                let nullStateCell = tableView.dequeueReusableCellWithIdentifier(Constants.MeetingSectionNullStateCellIdentifier, forIndexPath: indexPath) as! MeetingSectionNullStateCell
                switch self.mode {
                case .Upcoming:
                    nullStateCell.nullStateText = "you’ll be alerted if you receive a new meeting request"
                case .Organizing:
                    nullStateCell.nullStateText = "your unsent meeting invitations will be found here"
                }
                nullStateCell.selectionStyle = .None
                return nullStateCell
            } else if self.mode == .Organizing {
                let draftCell = tableView.dequeueReusableCellWithIdentifier(Constants.MeetingDraftCellIdentifier, forIndexPath: indexPath) as! MeetingDraftCell
                draftCell.title = meetings[indexPath.section][indexPath.row].title
                return draftCell
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as! MeetingTableViewCell
        cell.meeting = meetings[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.mode == .Organizing && indexPath.section == 0
    }
    
    // TODO: make with row animation by not reloading data
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let deletedMeeting = meetings[indexPath.section][indexPath.row]
            deletedMeeting.deleteDraft()
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            meetings[indexPath.section].removeAtIndex(indexPath.row)
        }
    }
    
    // MARK: Private Instance Variables
    
    private enum Mode {
        case Upcoming, Organizing
    }
    
    private var mode: Mode = .Upcoming
    
    // MARK: Constants
    
    private struct Constants {
        static let AwaitingResponseSection = "awaiting response"
        static let UpcomingSection = "upcoming"
        static let UnsentSection = "unsent"
        static let HostingSection = "hosting"
        static let SegueShowMeetingSummary = "Segue Show Meeting Summary"
        static let SegueMeetingResponse = "Segue Meeting Response"
        static let SegueCreateMeeting = "Segue Create Meeting"
        static let SegueEditMeeting = "Segue Edit Meeting"
        static let CellReuseIdentifier = "MeetingCell"
        static let MeetingDraftCellIdentifier = "MeetingDraftCell"
        static let MeetingSectionNullStateCellIdentifier = "MeetingSectionNullStateCell"
        static let HeaderCellIdentifier = "MeetTableViewHeaderCell"
        static let MeetingSummaryVCIdentifier = "MeetingSummaryTableViewController"
        static let MeetingResponseVCIdentifier = "ResponseTableViewController"
        static let MeetingComposerVCIdentifier = "ComposeMeetingViewController"
    }
}
