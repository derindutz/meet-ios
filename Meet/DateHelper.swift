//
//  DateHelper.swift
//  Meet
//
//  Created by Derin Dutz on 11/17/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import Foundation

public class DateHelper {
    
    // MARK: Public API
    
    public class func getDateEntryString(date: NSDate?) -> String? {
        if let d = date {
            let dayFormatter = NSDateFormatter()
            dayFormatter.dateFormat = "MMMM d"
            let dayString = dayFormatter.stringFromDate(d).lowercaseString
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.timeStyle = .ShortStyle
            let timeString = timeFormatter.stringFromDate(d).lowercaseString
            
            return "\(dayString) at \(timeString)"
        }
        return nil
    }
    
    public class func getDayString(date: NSDate?) -> String? {
        if let d = date {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.Day, fromDate: d)
            return "\(components.day)"
        }
        return nil
    }
    
    public class func getThreeLetterMonthString(date: NSDate?) -> String? {
        if let d = date {
            let monthFormatter = NSDateFormatter()
            monthFormatter.dateFormat = "MMM"
            return monthFormatter.stringFromDate(d).lowercaseString
        }
        return nil
    }
    
    public class func getTimeSubtitle(date: NSDate?) -> String? {
        if let d = date {
            let dayFormatter = NSDateFormatter()
            dayFormatter.dateFormat = "EEEE"
            let dayString = dayFormatter.stringFromDate(d).lowercaseString
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.timeStyle = .ShortStyle
            let timeString = timeFormatter.stringFromDate(d).lowercaseString
            
            return "\(dayString) at \(timeString)"
        }
        return nil
    }
    
    // TODO: implement this
    public class func getTimeUntilMeeting(meeting: Meeting) -> String {
        if let startDate = meeting.startDate {
            let now = NSDate()
            let userCalendar = NSCalendar.currentCalendar()
            let dayDifference = userCalendar.components(NSCalendarUnit.Day, fromDate: now, toDate: startDate, options: NSCalendarOptions()).day
            if dayDifference > 1 {
                return "in \(dayDifference) days"
            } else if dayDifference == 1 {
                return "in 1 day"
            }
            let hourDifference = userCalendar.components(NSCalendarUnit.Hour, fromDate: now, toDate: startDate, options: NSCalendarOptions()).hour
            if hourDifference > 1 {
                return "in \(hourDifference) hrs"
            } else if hourDifference == 1 {
                return "in 1 hr"
            }
            let minuteDifference = userCalendar.components(NSCalendarUnit.Minute, fromDate: now, toDate: startDate, options: NSCalendarOptions()).minute
            if minuteDifference > 1 {
                return "in \(minuteDifference) min"
            }
        }
        return "happening now"
    }
    
}