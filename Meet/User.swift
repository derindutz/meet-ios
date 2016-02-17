//
//  User.swift
//  Meet
//
//  Created by Derin Dutz on 11/17/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

public class User: CustomStringConvertible {
    public var id: String?
    public var username: String?
    public var firstName: String?
    public var lastName: String?
    public var emails = [String]()
    public var phoneNumbers = [String]()
    public var profileImageData: NSData?
    public var isRegistered = false
    
    public var fullName: String? {
        get {
            if let first = firstName, last = lastName {
                return "\(first) \(last)"
            }
            return nil
        }
        set {
            if let fullName = newValue {
                let fullNameArr = fullName.componentsSeparatedByString(" ")
                if (fullNameArr.count == 2) {
                    firstName = fullNameArr[0]
                    lastName = fullNameArr[1]
                } else {
                    firstName = fullName
                    lastName = fullName
                }
                
            }
        }
    }
    
    public var firstNameLastInitial: String? {
        get {
            if (lastName?.isEmpty == false) {
                if let first = firstName, last = lastName {
                    return "\(first) \(last[last.startIndex])."
                }
                
            }
            return nil
        }
    }
    
    public var initials: String? {
        get {
            if let first = self.firstInitial, last = self.lastInitial {
                return "\(first)\(last)"
            } else if let first = self.firstInitial {
                return "\(first)"
            } else if let last = self.lastInitial {
                return "\(last)"
            } else {
                return nil
            }
        }
    }
    
    public var firstInitial: String? {
        get {
            if let first = self.firstName {
                if !first.isEmpty {
                    return "\(first[first.startIndex])"
                }
            }
            return nil
        }
    }
    
    public var lastInitial: String? {
        get {
            if let last = self.lastName {
                if !last.isEmpty {
                    return "\(last[last.startIndex])"
                }
            }
            return nil
        }
    }
    
    public func getProfileImage() -> UIImage? {
        if let data = self.profileImageData {
            return UIImage(data: data)
        }
        return nil
    }
    
    public class func union(primaryUser: User, secondaryUser: User) -> User {
        let newUser = primaryUser
        if newUser.username == nil {
            newUser.username = secondaryUser.username
        }
        if newUser.firstName == nil {
            newUser.firstName = secondaryUser.firstName
        }
        if newUser.lastName == nil {
            newUser.lastName = secondaryUser.lastName
        }
        
        newUser.emails.appendContentsOf(secondaryUser.emails)

        newUser.phoneNumbers.appendContentsOf(secondaryUser.phoneNumbers)
        
        if newUser.profileImageData == nil {
            newUser.profileImageData = secondaryUser.profileImageData
        }
        
        newUser.isRegistered = newUser.isRegistered || secondaryUser.isRegistered
        
        return newUser
    }
    
    public var description: String { return "(\(username) \(firstName) \(lastName), \(emails), \(phoneNumbers), \(isRegistered))" }
}
