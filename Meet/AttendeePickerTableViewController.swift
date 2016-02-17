//
//  AttendeePickerTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 2/12/16.
//  Copyright © 2016 Derin Dutz. All rights reserved.
//

import UIKit

class AttendeePickerTableViewController: MeetTableViewController {
    
    // MARK: Public API
    
    var attendees = [String]() {
        didSet {
            var tempUserDict = [String: [(user: User, isInvited: Bool)]]()
            AddressBookHelper.getUsers()
            let users = UserDatabase.getUsers()
            for (username, user) in users {
                var key = "#"
                if let lastInitial = user.firstInitial {
                    key = lastInitial.uppercaseString
                } else if let firstInitial = user.lastInitial {
                    key = firstInitial.uppercaseString
                }
                if tempUserDict[key] == nil {
                    tempUserDict[key] = []
                }
                tempUserDict[key]?.append((user, attendees.contains(username)))
            }
            
            self.cellModel = [[(user: User, isInvited: Bool)]]()
            self.sectionModel = [String]()
            self.sectionIndexMatching = [Int]()
            
            var sectionIndex = 0
            for sectionTitle in self.sectionIndexTitles {
                self.sectionIndexMatching.append(sectionIndex)
                if let sectionUsers = tempUserDict[sectionTitle] {
                    self.sectionModel.append(sectionTitle)
                    self.cellModel.append(sectionUsers)
                    sectionIndex++
                }
            }
        }
    }
    
    private var cellModel = [[(user: User, isInvited: Bool)]]()
    private var sectionModel = [String]()
    private var sectionIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]
    private var sectionIndexMatching = [Int]()
    
    // View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navcon = self.navigationController as? AttendeePickerNavigationController {
            self.attendees = navcon.attendees
        }
        tableView.reloadData()
    }
    
    // Storyboard Connectivity
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Constants.DoneSegueIdentifier {
                if let ctvc = segue.destinationViewController as? MeetingComposerSummaryTableViewController {
                    var attendees = [String]()
                    for section in self.cellModel {
                        for userPair in section {
                            print(userPair)
                            if userPair.isInvited {
                                attendees.append(userPair.user.username!)
                            }
                        }
                    }
                    ctvc.meeting.attendees = attendees
                }
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    // MARK: Cells
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionModel.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellModel[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.AttendeePickerCellIdentifier, forIndexPath: indexPath) as! AttendeePickerCell
        let cellModel = self.cellModel[indexPath.section][indexPath.row]
        cell.name = cellModel.user.fullName
        cell.isAttending = cellModel.isInvited
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.cellModel[indexPath.section][indexPath.row].isInvited = !self.cellModel[indexPath.section][indexPath.row].isInvited
        tableView.reloadData()
    }
    
    // MARK: Headers

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionModel[section]
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.sectionIndexTitles
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return self.sectionIndexMatching[index]
    }
    
    // MARK: Constants
    
    private struct Constants {
        static let AttendeePickerCellIdentifier = "AttendeePickerCellIdentifier"
        static let CancelSegueIdentifier = "cancelAddAttendees"
        static let DoneSegueIdentifier = "attendeesAdded"
    }
    
}

