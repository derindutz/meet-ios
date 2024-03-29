//
//  Meeting.swift
//  Meet
//
//  Created by Derin Dutz on 11/15/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import Foundation

public class Meeting: CustomStringConvertible, Comparable {

    public enum Status: String {
        case New = "New"
        case Draft = "Draft"
        case Sent = "Sent"
    }
    
    public var id: String?
    public var status: Status = .New
    public var host: String = CurrentUser.username
    public var title: String?
    public var startDate: NSDate?
    public var duration: Int?
    public var location: String?
    public var attendees: [String] = [CurrentUser.username]
    public var respondedYes: [String] = [String]()
    public var respondedNo: [String] = [String]()
    public var talkingPoints: [TalkingPoint] = [TalkingPoint]()
    
    public var description: String { return "{(\(id)) title: \(title); date: \(startDate); host: \(host); attendees: \(attendees); respondedYes: \(respondedYes); respondedNo: \(respondedNo); talking points: \(talkingPoints)}" }
    
    public func isEmpty() -> Bool {
        return title == nil
            && startDate == nil
            && duration == nil
            && location == nil
            && (attendees.isEmpty || (attendees.count == 1 && attendees.contains(CurrentUser.username)))
            && talkingPoints.isEmpty
    }
    
    public func isReadyToSend() -> Bool {
        return host == CurrentUser.username
            && title != nil && title != ""
            && startDate != nil
            && duration != nil && duration >= 0
            && location != nil && location != ""
            && !attendees.isEmpty
            && !talkingPoints.isEmpty
    }
    
    public func createInDatabase() {
        MeetingDatabase.create(self)
    }
    
    public func copy() -> Meeting {
        let meeting = Meeting()
        meeting.id = self.id
        meeting.status = self.status
        meeting.host = self.host
        meeting.title = self.title
        meeting.startDate = self.startDate
        meeting.duration = self.duration
        meeting.location = self.location
        meeting.attendees = self.attendees
        meeting.respondedYes = self.respondedYes
        meeting.respondedNo = self.respondedNo
        meeting.talkingPoints = self.talkingPoints
        return meeting
    }
    
    public func send() -> Bool {
        if isReadyToSend() {
            switch self.status {
            case .New:
                self.status = Status.Sent
                MeetingDatabase.create(self)
            default:
                self.status = Status.Sent
                MeetingDatabase.update(self)
            }
            return true
        }
        
        print("invalid send")
        return false
    }
    
    public func saveAsDraft() -> Bool {
        switch self.status {
        case .New:
            self.status = .Draft
            MeetingDatabase.create(self)
            return true
        case .Draft:
            MeetingDatabase.update(self)
            return true
        default:
            return false
        }
    }

//    public func save() -> Bool {
//        switch self.status {
//        case .Draft:
//            MeetingDatabase.update(self)
//            return true
//        default:
//            return false
//        }
//    }
    
    public func cancel() -> Bool {
        MeetingDatabase.cancel(self)
        return true
    }
    
    public func deleteDraft() -> Bool {
        switch self.status {
        case .New:
            return true
        case .Draft:
            MeetingDatabase.deleteDraft(self)
            return true
        default:
            return false
        }
    }
    
    public func respond() -> Bool {
        MeetingDatabase.respond(self)
        return true
    }
}

public func < (lhs: Meeting, rhs: Meeting) -> Bool {
    if let rhsStart = rhs.startDate {
        if let lhsStart = lhs.startDate {
            return rhsStart.compare(lhsStart) == .OrderedDescending
        }
        return false
    }
    
    if let rhsTitle = rhs.title {
        if let lhsTitle = lhs.title {
            return rhsTitle.compare(lhsTitle) == .OrderedDescending
        }
        return false
    }
    return true
}

public func == (lhs: Meeting, rhs: Meeting) -> Bool {
    return lhs.id == rhs.id
        && lhs.status == rhs.status
        && lhs.host == rhs.host
        && lhs.title == rhs.title
        && lhs.startDate == rhs.startDate
        && lhs.duration == rhs.duration
        && lhs.attendees == rhs.attendees
        && lhs.respondedYes == rhs.respondedYes
        && lhs.respondedNo == rhs.respondedNo
        && lhs.talkingPoints == rhs.talkingPoints
}