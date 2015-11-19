//
//  User.swift
//  Meet
//
//  Created by Derin Dutz on 11/17/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import Foundation

public class User: CustomStringConvertible {
    public var username: String?
    public var firstName: String?
    public var lastName: String?
    
    public var fullName: String {
        get {
            if let first = firstName, last = lastName {
                return "\(first) \(last)"
            }
            return ""
        }
        set {
            let fullNameArr = newValue.componentsSeparatedByString(" ")
            firstName = fullNameArr[0]
            lastName = fullNameArr[1]
        }
    }
    
    public var description: String { return "\(firstName) \(lastName) (\(username))" }
}
