//
//  User.swift
//  Meet
//
//  Created by Derin Dutz on 11/17/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

public class User: CustomStringConvertible {
    public var username: String?
    public var firstName: String?
    public var lastName: String?
    public var profileImageData: NSData?
    
    public var contactIdentifier: String?
    
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
            if let first = firstName, last = lastName {
                if !first.isEmpty && !last.isEmpty {
                    return "\(first[first.startIndex])\(last[last.startIndex])"
                }
            }
            if let first = firstName {
                if !first.isEmpty {
                    return "\(first[first.startIndex])"
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
    
    public var description: String { return "(\(username))" }
}
