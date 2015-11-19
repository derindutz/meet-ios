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
    
}