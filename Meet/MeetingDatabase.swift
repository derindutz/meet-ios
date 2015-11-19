//
//  MeetingDatabase.swift
//  Meet
//
//  Created by Derin Dutz on 11/16/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import Foundation
import Parse

public class MeetingDatabase {
    
    // MARK: Public API
    
    public class func create(meeting: Meeting) {
        if let currentUser = PFUser.currentUser() {
            let pfMeeting = PFObject(className: "Meeting")
            pfMeeting["host"] = currentUser
            saveMeetingToPFObject(meeting, pfObject: pfMeeting)
        }
    }
    
    public class func update(meeting: Meeting) {
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
    
    private class func saveMeetingToPFObject(meeting: Meeting, pfObject: PFObject) {
        pfObject["title"] = meeting.title ?? NSNull()
        pfObject["startDate"] = meeting.startDate ?? NSNull()
        pfObject["duration"] = meeting.duration ?? NSNull()
        pfObject["location"] = meeting.location ?? NSNull()
        pfObject["attendees"] = meeting.attendees
        pfObject["talkingPoints"] = meeting.talkingPoints
        pfObject.saveInBackground()
    }
    
    public class func getOrganizingMeetings() -> [[Meeting]] {
        var meetings = [[Meeting]]()
        meetings.append([Meeting]())
        meetings.append([Meeting]())
        
        if let currentUser = PFUser.currentUser() {
            let query = PFQuery(className: "Meeting")
            query.whereKey("host", equalTo: currentUser)
            
            let now = NSDate()
            query.whereKey("startDate", greaterThanOrEqualTo: now)
            query.orderByAscending("startDate")
            
            do {
                let results = try query.findObjects()
                for pfMeeting in results {
                    let meeting = Meeting()
                    meeting.id = pfMeeting.objectId
                    meeting.title = pfMeeting["title"] as? String
                    meeting.startDate = pfMeeting["startDate"] as? NSDate
                    meeting.duration = pfMeeting["duration"] as? Int
                    meeting.location = pfMeeting["location"] as? String
                    meeting.attendees = (pfMeeting["attendees"] as? [String]) ?? [String]()
                    meeting.talkingPoints = (pfMeeting["talkingPoints"] as? [String]) ?? [String]()
                    meetings[1].append(meeting)
                }
            } catch _ {
                print("Error occurred when finding objects in datbase.")
            }
        }
        
        return meetings
    }
}
