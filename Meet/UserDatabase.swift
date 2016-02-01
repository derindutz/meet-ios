//
//  UserDatabase.swift
//  Meet
//
//  Created by Derin Dutz on 11/17/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import Foundation
import Parse

public class UserDatabase {
    
    // MARK: Public API
    
    static var users = [String: User]()
    
    public class func addUser(user: User) {
        if let username = user.username {
            users[username] = user
        }
    }
    
    public class func containsUser(username: String) -> Bool {
        return users[username] != nil
    }
    
    public class func getUser(username: String) -> User? {
        print("getting user: \(username)")
        if let user = users[username] {
            if user.username != nil {
                print("found user in database: \(user)")
                return user
            }
        }

        AddressBookHelper.getUser(username)
        
        if let user = users[username] {
            if user.username != nil {
                print("found user after getting from address book: \(user)")
                return user
            }
        }

//        let query = PFQuery(className: "InternalUser")
//        query.whereKey("username", equalTo: username)
//        do {
//            let results = try query.findObjects()
//            if !results.isEmpty {
//                let pfUser = results[0]
//                let user = User()
//                user.username = username
//                user.firstName = pfUser["firstName"] as? String
//                user.lastName = pfUser["lastName"] as? String
//                users[username] = user
//                print("found user from parse: \(user)")
//                return user
//            }
//        } catch _ {
//            print("Error occurred when finding users in database.")
//        }
        
        print("no user found for \(username)")
        return nil
    }
    
    public class func create(user: User) {
        // TODO: remove
        print("creating new user: \(user)")
        if let username = user.username {
            users[username] = user
            let pfUser = PFObject(className: "InternalUser")
            pfUser["username"] = username
            pfUser["firstName"] = user.firstName ?? NSNull()
            pfUser["lastName"] = user.lastName ?? NSNull()
            pfUser.saveInBackground()
        }
    }
}
