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
    
    // MARK: Local Functions
    
    public class func setUser(username: String, user: User) {
        users[username] = user
    }
    
    public class func updateUser(username: String, user: User) {
        if let savedUser = users[username] {
            users[username] = User.union(savedUser, secondaryUser: user)
        } else {
            users[username] = user
        }
    }
    
    public class func addUser(user: User) {
        if let username = user.username {
            users[username] = user
        }
    }
    
    public class func containsUser(username: String) -> Bool {
        return users[username] != nil
    }
    
    public class func getUsers() -> [String: User] {
        return self.users
    }
    
    public class func getUser(username: String) -> User? {
        return users[username]
    }
    
    // MARK: Database Functions
    
    public class func saveUserToDatabase(username: String, user: User) {
        if let savedUser = loadUser(username) {
            let updatedUser = User.union(savedUser, secondaryUser: user)
            updateUserInDatabase(updatedUser)
        } else {
            createUserInDatabase(user)
        }
    }
    
    public class func load() {
        let query = PFQuery(className: "InternalUser")
        do {
            let results = try query.findObjects()
            for pfUser in results {
                let user = getUserFromPFObject(pfUser)
                if let username = user.username {
                    users[username] = user
                }
            }
            print("LOADED:")
            print(users)
        } catch _ {
            print("Error occurred when finding users in database.")
        }
    }
    
    // MARK: Private Implementation
    
    private class func createUserInDatabase(user: User) {
        let pfUser = getPFObjectFromUser(user)
        pfUser.saveInBackground()
    }
    
    private class func createUserInDatabaseSynch(user: User) {
        let pfUser = getPFObjectFromUser(user)
        do {
            try pfUser.save()
        } catch _ {
            print("Error occurred when creating user in database.")
        }
    }
    
    private class func updateUserInDatabase(user: User) {
        if let id = user.id {
            let query = PFQuery(className: "InternalUser")
            query.getObjectInBackgroundWithId(id) {
                (pfUser: PFObject?, error: NSError?) -> Void in
                if error == nil && pfUser != nil {
                    setPFObjectFromUser(pfUser!, user: user)
                    pfUser?.saveInBackground()
                } else {
                    print(error)
                }
            }
        }
    }
    
    private class func updateUserInDatabaseSynch(user: User) {
        if let id = user.id {
            let query = PFQuery(className: "InternalUser")
            do {
                let pfUser = try query.getObjectWithId(id)
                setPFObjectFromUser(pfUser, user: user)
                try pfUser.save()
            } catch _ {
                print("Error occurred when updating user in database.")
            }
        }
    }
    
    // TODO: background load
//    private class func loadUserInBackground(username: String) -> User? {
//        let query = PFQuery(className: "InternalUser")
//        query.whereKey("username", equalTo: username)
//        query.findObjectsInBackgroundWithBlock {
//            (results: [PFObject]?, error: NSError?) -> Void in
//            if error == nil && results != nil {
//                if !results!.isEmpty {
//                    let pfUser = results![0]
//                    return getUserFromPFObject(pfUser)
//                }
//            }
//        }
//        return nil
//    }
    
    private class func loadUser(username: String) -> User? {
        let query = PFQuery(className: "InternalUser")
        query.whereKey("username", equalTo: username)
        do {
            let results = try query.findObjects()
            if !results.isEmpty {
                let pfUser = results[0]
                return getUserFromPFObject(pfUser)
            }
        } catch _ {
            print("Error occurred when finding users in database.")
        }
        return nil
    }
    
    private class func getPFObjectFromUser(user: User) -> PFObject {
        let pfUser = PFObject(className: "InternalUser")
        setPFObjectFromUser(pfUser, user: user)
        return pfUser
    }
    
    private class func setPFObjectFromUser(pfUser: PFObject, user: User) {
        pfUser["username"] = user.username ?? NSNull()
        pfUser["firstName"] = user.firstName ?? NSNull()
        pfUser["lastName"] = user.lastName ?? NSNull()
        pfUser["emails"] = user.emails
        pfUser["phoneNumbers"] = user.phoneNumbers
        // TODO: add profile picture
        pfUser["isRegistered"] = user.isRegistered
    }
    
    private class func getUserFromPFObject(pfUser: PFObject) -> User {
        let user = User()
        user.id = pfUser.objectId
        user.username = pfUser["username"] as? String
        user.firstName = pfUser["firstName"] as? String
        user.lastName = pfUser["lastName"] as? String
        
        if let emails = pfUser["emails"] as? [String] {
            user.emails = emails
        }
        
        if let phoneNumbers = pfUser["phoneNumbers"] as? [String] {
            user.phoneNumbers = phoneNumbers
        }

        // TODO: add profile picture
        if let isRegistered = pfUser["isRegistered"] as? Bool {
            user.isRegistered = isRegistered
        }
        
        return user
    }
}
