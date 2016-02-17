//
//  MeetingDatabase.swift
//  Meet
//
//  Created by Derin Dutz on 11/16/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit
import Parse

public class MeetingDatabase {
    
    // TODO: cache meetings
    // TODO: fix issue where someone rsvping to a meeting at the same time as someone else will overwrite their response
    // TODO: next meeting needs to be one that user has responded to
    
    // MARK: Public API
    
    // MARK: Single Meeting Actions
    
    private class func checkForAwaitingRespone() {
        if self.upcomingMeetings[0].isEmpty {
            self.isAwaitingResponse = false
        } else {
            self.isAwaitingResponse = false
        }
    }
    
    public class func create(meeting: Meeting) {
        createInDatabase(meeting)
        createLocally(meeting)
        checkForAwaitingRespone()
    }
    
    public class func update(meeting: Meeting) {
        print("updating meeting: \(meeting)")
        if meeting.isEmpty() {
            print("meeting is empty...deleting")
            delete(meeting)
        } else {
            updateLocally(meeting)
            updateInDatabase(meeting)
        }
        
        checkForAwaitingRespone()
    }
    
    public class func cancel(meeting: Meeting) {
        print("cancelling meeting: \(meeting)")
        delete(meeting)
        
        checkForAwaitingRespone()
    }
    
    public class func deleteDraft(meeting: Meeting) {
        print("deleting draft \(meeting)")
        delete(meeting)
        
        checkForAwaitingRespone()
    }
    
    public class func respond(meeting: Meeting) {
        updateLocally(meeting)
        respondInDatabase(meeting)
        
        checkForAwaitingRespone()
    }
    
    // MARK: Retrieving Meetings
    
    public class func loadMeetings() {
        self.upcomingMeetings = loadUpcomingMeetings()
        self.organizingMeetings = loadOrganizingMeetings()
    }
    
    public class func getNextMeeting() -> Meeting? {
        sortUpcomingMeetings()
        if !self.upcomingMeetings.isEmpty {
            return self.upcomingMeetings[1].first
        }
        
        return nil
    }
    
    private class func sortUpcomingMeetings() {
        if !self.upcomingMeetings.isEmpty {
            if !self.upcomingMeetings[0].isEmpty {
                self.upcomingMeetings[0].sortInPlace()
            }
            
            if !self.upcomingMeetings[1].isEmpty {
                self.upcomingMeetings[1].sortInPlace()
            }
        }
    }
    
    public class func getUpcomingMeetings() -> [[Meeting]] {
        sortUpcomingMeetings()
        return self.upcomingMeetings
    }
    
    public class func loadUpcomingMeetings() -> [[Meeting]] {
        var meetings = [[Meeting]]()
        meetings.append([Meeting]())
        meetings.append([Meeting]())
        
        let query = PFQuery(className: "Meeting")
        query.whereKey("attendees", containsAllObjectsInArray: [CurrentUser.username])
        query.whereKey("status", equalTo: "\(Meeting.Status.Sent)")
        
        let now = NSDate()
        query.whereKey("startDate", greaterThanOrEqualTo: now)
        query.orderByAscending("startDate")
        
        do {
            let results = try query.findObjects()
            var isAwaitingResponse = false
            for pfMeeting in results {
                let meeting = getMeetingFromPFObject(pfMeeting)
                if meeting.respondedYes.contains(CurrentUser.username) {
                    meetings[1].append(meeting)
                } else if !meeting.respondedNo.contains(CurrentUser.username) {
                    isAwaitingResponse = true
                    meetings[0].append(meeting)
                }
            }
            self.isAwaitingResponse = isAwaitingResponse
        } catch _ {
            print("Error occurred when finding objects in datbase.")
        }
        
        return meetings
    }
    
    private class func sortOrganizingMeetings() {
        if !self.organizingMeetings.isEmpty {
            if !self.organizingMeetings[0].isEmpty {
                self.organizingMeetings[0].sortInPlace()
            }
            
            if !self.organizingMeetings[1].isEmpty {
                self.organizingMeetings[1].sortInPlace()
            }
        }
    }
    
    public class func getOrganizingMeetings() -> [[Meeting]] {
        sortOrganizingMeetings()
        return self.organizingMeetings
    }
    
    public class func loadOrganizingMeetings() -> [[Meeting]] {
        var meetings = [[Meeting]]()
        meetings.append([Meeting]())
        meetings.append([Meeting]())
        
        let hostingQuery = PFQuery(className: "Meeting")
        let now = NSDate()
        hostingQuery.whereKey("host", equalTo: CurrentUser.username)
        hostingQuery.whereKey("status", equalTo: "\(Meeting.Status.Sent)")
        hostingQuery.whereKey("startDate", greaterThanOrEqualTo: now)
        hostingQuery.orderByAscending("startDate")
        
        do {
            let results = try hostingQuery.findObjects()
            for pfMeeting in results {
                meetings[1].append(getMeetingFromPFObject(pfMeeting))
            }
        } catch _ {
            print("Error occurred when finding hosting meetings in datbase.")
        }
        
        let unsentQuery = PFQuery(className: "Meeting")
        unsentQuery.whereKey("host", equalTo: CurrentUser.username)
        unsentQuery.whereKey("status", equalTo: "\(Meeting.Status.Draft)")
        unsentQuery.orderByAscending("startDate")
        
        do {
            let results = try unsentQuery.findObjects()
            for pfMeeting in results {
                meetings[0].append(getMeetingFromPFObject(pfMeeting))
            }
        } catch _ {
            print("Error occurred when finding unsent meetings in datbase.")
        }
        
        return meetings
    }
    
    public class func getDailyTimeSpentInMeetings() -> [Int] {
        
//        var dayToDuration: [Int:Int] = [:]
//        
//        var meetingResults = [Meeting]()
//        
//        var durationTimes = [Int]()
//        
//        let timeSpentQuery = PFQuery(className: "Meeting")
//        timeSpentQuery.whereKey("respondedYes", equalTo: CurrentUser.username)
//        timeSpentQuery.orderByAscending("startDate")
//        do {
//            let results = try timeSpentQuery.findObjects()
//            for pfMeeting in results {
//                meetingResults.append(getMeetingFromPFObject(pfMeeting))
//            }
//        } catch _ {
//            print("Error occurred when finding meetings for analytics in datbase.")
//        }
//        
//        
//        for pfMeeting in meetingResults {
//            let calendar = NSCalendar.currentCalendar()
//            let components = calendar.components([.Day , .Month , .Year], fromDate: pfMeeting.startDate!)
//            //let year =  components.year
//            let month = components.month
//            let day = components.day
//            // TODO: fix this little hack
//            let daySignature = 30*month + day // + 365*year
//            
//            let currDuration = pfMeeting.duration!
//            //print(dayToDuration[daySignature]!)
//            let newDuration = dayToDuration[daySignature] != nil ? dayToDuration[daySignature]! + currDuration : currDuration
//            dayToDuration.updateValue(newDuration, forKey: daySignature)
//        }
//        
//        let minDay = dayToDuration.keys.minElement()
//        let maxDay = dayToDuration.keys.maxElement()
//        
//        if minDay == nil {
//            return []
//        }
//        
//        for var i = minDay; i <= maxDay; i = i! + 1 {
//            if dayToDuration[i!] != nil {
//                durationTimes.append(dayToDuration[i!]!)
//            } else {
//                durationTimes.append(0)
//            }
//        }
//        
//        return durationTimes
        
        return [195, 205, 187, 183, 216, 184, 235, 211, 216, 203, 221, 217, 234, 182, 187, 222, 196, 215, 186, 186, 165, 147, 169, 218, 131, 127, 158, 201, 152, 182, 172, 198, 191, 197, 165, 121, 133, 194, 186, 104, 100, 68, 94, 141, 114, 90, 82, 150, 120, 135, 88, 105, 67, 63, 74, 93, 79, 76, 134, 26, 61, 16, 35, 61, 27, 51, 0, 38, 39, 28, 0, 51, 29, 65, 0, 58, 60, 30, 42]
        
    }
    
    private class func randomRange(lower: Int, upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    // MARK: Private Implementation
    
    private class func findMeetingIndex(meeting: Meeting, amongMeetings: [[Meeting]]) -> (section: Int, index: Int)? {
        for (section, meetings) in amongMeetings.enumerate() {
            for (index, existingMeeting) in meetings.enumerate() {
                if existingMeeting.id == meeting.id {
                    return (section, index)
                }
            }
        }
        return nil
    }
    
    private class func createInDatabase(meeting: Meeting) {
        let pfMeeting = PFObject(className: "Meeting")
        pfMeeting["host"] = meeting.host
        pfMeeting["status"] = "\(meeting.status)"
        pfMeeting["title"] = meeting.title ?? NSNull()
        pfMeeting["startDate"] = meeting.startDate ?? NSNull()
        pfMeeting["duration"] = meeting.duration ?? NSNull()
        pfMeeting["location"] = meeting.location ?? NSNull()
        pfMeeting["attendees"] = meeting.attendees
        pfMeeting["respondedYes"] = meeting.respondedYes
        pfMeeting["respondedNo"] = meeting.respondedNo
        pfMeeting["talkingPoints"] = meeting.talkingPoints.map(TalkingPoint.toStorageString)
        pfMeeting.saveInBackgroundWithBlock({
            (success, error) -> Void in
            if success {
                meeting.id = pfMeeting.objectId
            } else {
                print(error)
            }
        })
        print("created meeting: \(meeting)")
    }
    
    private class func createLocally(meeting: Meeting) {
        var isMeetingFuture = false
        if let start = meeting.startDate {
            isMeetingFuture = start.compare(NSDate()) != NSComparisonResult.OrderedAscending
            print("is meeting future? \(isMeetingFuture)")
        }
        
        if isMeetingFuture && meeting.status == .Sent && meeting.attendees.contains(CurrentUser.username) {
            if meeting.respondedYes.contains(CurrentUser.username) {
                self.upcomingMeetings[1].append(meeting)
            } else if !meeting.respondedNo.contains(CurrentUser.username) {
                self.upcomingMeetings[0].append(meeting)
            }
        }
        
        if meeting.host == CurrentUser.username {
            if meeting.status == .Draft {
                self.organizingMeetings[0].append(meeting)
            } else if isMeetingFuture {
                self.organizingMeetings[1].append(meeting)
            }
        }
    }
    
    private class func updateLocally(meeting: Meeting) {
        deleteLocally(meeting)
        
        var isMeetingFuture = false
        if let start = meeting.startDate {
            isMeetingFuture = start.compare(NSDate()) != NSComparisonResult.OrderedAscending
            print("is meeting future? \(isMeetingFuture)")
        }
        
        if isMeetingFuture && meeting.status == .Sent && meeting.attendees.contains(CurrentUser.username) {
            if meeting.respondedYes.contains(CurrentUser.username) {
                self.upcomingMeetings[1].append(meeting)
            } else if !meeting.respondedNo.contains(CurrentUser.username) {
                self.upcomingMeetings[0].append(meeting)
            }
        }
        
        if meeting.host == CurrentUser.username {
            if meeting.status == .Draft {
                self.organizingMeetings[0].append(meeting)
            } else if isMeetingFuture {
                self.organizingMeetings[1].append(meeting)
            }
        }
        
//        if let organizingIndices = findMeetingIndex(meeting, amongMeetings: self.organizingMeetings) {
//            self.organizingMeetings[organizingIndices.0][organizingIndices.1] = meeting
//        }
//        if let upcomingIndices = findMeetingIndex(meeting, amongMeetings: self.upcomingMeetings) {
//            if upcomingIndices.0 == 0 { // Awaiting Response
//                if meeting.respondedNo.contains(CurrentUser.username) {
//                    self.upcomingMeetings[0].removeAtIndex(upcomingIndices.1)
//                } else if meeting.respondedYes.contains(CurrentUser.username) {
//                    self.upcomingMeetings[0].removeAtIndex(upcomingIndices.1)
//                    self.upcomingMeetings[1].append(meeting)
//                } else {
//                    self.upcomingMeetings[0][upcomingIndices.1] = meeting
//                }
//            } else { // Upcoming
//                
//            }
//            
//        }
    }
    
    private class func updateInDatabase(meeting: Meeting) {
        if let id = meeting.id {
            let query = PFQuery(className: "Meeting")
            query.getObjectInBackgroundWithId(id) {
                (pfMeeting: PFObject?, error: NSError?) -> Void in
                if error == nil && pfMeeting != nil {
                    saveMeetingToPFObject(meeting, pfObject: pfMeeting!)
                } else {
                    print(error)
                }
            }
        }
    }
    
    private class func respondInDatabase(meeting: Meeting) {
        if let id = meeting.id {
            let query = PFQuery(className: "Meeting")
            query.getObjectInBackgroundWithId(id) {
                (pfMeeting: PFObject?, error: NSError?) -> Void in
                if error == nil && pfMeeting != nil {
                    let savedMeeting = getMeetingFromPFObject(pfMeeting!)
                    if !savedMeeting.respondedYes.contains(CurrentUser.username) && !savedMeeting.respondedNo.contains(CurrentUser.username) {
                        if meeting.respondedYes.contains(CurrentUser.username) {
                            savedMeeting.respondedYes.append(CurrentUser.username)
                            for (index, talkingPoint) in savedMeeting.talkingPoints.enumerate() {
                                if meeting.talkingPoints[index].relevantUsers.contains(CurrentUser.username) {
                                    talkingPoint.relevantUsers.append(CurrentUser.username)
                                }
                            }
                        } else if meeting.respondedNo.contains(CurrentUser.username) {
                            savedMeeting.respondedNo.append(CurrentUser.username)
                        }
                        saveMeetingToPFObject(savedMeeting, pfObject: pfMeeting!)
                    }
                } else {
                    print(error)
                }
            }
        }
    }
    
    private class func delete(meeting: Meeting) {
        deleteLocally(meeting)
        deleteInDatabase(meeting)
    }
    
    private class func deleteLocally(meeting: Meeting) {
        if let organizingIndices = findMeetingIndex(meeting, amongMeetings: self.organizingMeetings) {
            self.organizingMeetings[organizingIndices.0].removeAtIndex(organizingIndices.1)
        }
        if let upcomingIndices = findMeetingIndex(meeting, amongMeetings: self.upcomingMeetings) {
            self.upcomingMeetings[upcomingIndices.0].removeAtIndex(upcomingIndices.1)
        }
    }
    
    private class func deleteInDatabase(meeting: Meeting) {
        if let id = meeting.id {
            let query = PFQuery(className: "Meeting")
            query.getObjectInBackgroundWithId(id) {
                (pfMeeting: PFObject?, error: NSError?) -> Void in
                if error == nil && pfMeeting != nil {
                    pfMeeting!.deleteInBackground()
                } else {
                    print(error)
                }
            }
        }
    }
    
    private class func saveMeetingToPFObject(meeting: Meeting, pfObject: PFObject) {
        pfObject["status"] = "\(meeting.status)"
        pfObject["host"] = meeting.host
        pfObject["title"] = meeting.title ?? NSNull()
        pfObject["startDate"] = meeting.startDate ?? NSNull()
        pfObject["duration"] = meeting.duration ?? NSNull()
        pfObject["location"] = meeting.location ?? NSNull()
        pfObject["attendees"] = meeting.attendees
        pfObject["respondedYes"] = meeting.respondedYes
        pfObject["respondedNo"] = meeting.respondedNo
        pfObject["talkingPoints"] = meeting.talkingPoints.map(TalkingPoint.toStorageString)
        pfObject.saveInBackground()
    }
    
    private class func getMeetingFromPFObject(pfMeeting: PFObject) -> Meeting {
        let meeting = Meeting()
        meeting.id = pfMeeting.objectId
        if let statusStr = pfMeeting["status"] as? String {
            if let status = Meeting.Status(rawValue: statusStr) {
                meeting.status = status
            }
        }
        meeting.host = (pfMeeting["host"] as? String)!
        meeting.title = pfMeeting["title"] as? String
        meeting.startDate = pfMeeting["startDate"] as? NSDate
        meeting.duration = pfMeeting["duration"] as? Int
        meeting.location = pfMeeting["location"] as? String
        meeting.attendees = (pfMeeting["attendees"] as? [String]) ?? [String]()
        meeting.respondedYes = (pfMeeting["respondedYes"] as? [String]) ?? [String]()
        meeting.respondedNo = (pfMeeting["respondedNo"] as? [String]) ?? [String]()
        if let pfTalkingPoints = pfMeeting["talkingPoints"] as? [String] {
            meeting.talkingPoints = pfTalkingPoints.map(TalkingPoint.fromStorageString)
        }
        return meeting
    }

    private static var upcomingMeetings = [[Meeting]]()
    private static var organizingMeetings = [[Meeting]]()
    public static var isAwaitingResponse = false {
        didSet {
            if self.isAwaitingResponse {
                if let tabItem = self.badgeTabItem {
                    tabItem.image = UIImage(named: "tab_upcoming_with_badge")?.imageWithRenderingMode(.AlwaysOriginal)
                    tabItem.selectedImage = UIImage(named: "tab_upcoming_with_badge")
                }
            } else {
                if let tabItem = self.badgeTabItem {
                    tabItem.image = UIImage(named: "tab_upcoming")
                    tabItem.selectedImage = UIImage(named: "tab_upcoming")
                }
            }
        }
    }
    public static var badgeTabItem: UITabBarItem?
}
