//
//  Meeting.swift
//  Meet
//
//  Created by Derin Dutz on 11/15/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import Foundation

public class Meeting: CustomStringConvertible {
    
    public var id: String?
    
    public var title: String?
    public var startDate: NSDate?
    public var duration: Int?
    
    public var location: String?
    
    public var attendees: [String] = [String]()
    public var talkingPoints: [String] = [String]()
    
    public var description: String { return "\(title) at \(startDate) takes \(duration) and is at \(location). Attendees: \(attendees). Talking points: \(talkingPoints)" }
}