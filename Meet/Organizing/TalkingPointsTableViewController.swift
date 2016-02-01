//
//  TalkingPointsTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/15/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class TalkingPointsTableViewController: MeetingComposerTableViewController {
    
    // MARK: Public API
    
    var meeting: Meeting = Meeting() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Constants
    
    private struct Storyboard {
        static let TalkingPointsTitleCellIdentifier = "TalkingPointsTitleCell"
        static let TalkingPointCellIdentifier = "TalkingPointCell"
        static let NewTalkingPointCellIdentifier = "NewTalkingPointCell"
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
        self.meetingDataSource.meeting.talkingPoints = self.meeting.talkingPoints
    }
    
    @IBAction func newTalkingPointComposed(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    
    @IBAction func cancelComposeTalkingPoint(segue: UIStoryboardSegue) {
        // Empty.
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return meeting.talkingPoints.count
        default:
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TalkingPointsTitleCellIdentifier, forIndexPath: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TalkingPointCellIdentifier, forIndexPath: indexPath) as! TalkingPointsTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.talkingPoint = meeting.talkingPoints[indexPath.row]
            cell.delegate = self
            cell.row = indexPath.row
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.NewTalkingPointCellIdentifier, forIndexPath: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func removeTalkingPoint(row: Int) {
        self.meeting.talkingPoints.removeAtIndex(row)
        tableView.reloadData()
    }
}

