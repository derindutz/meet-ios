//
//  Account.swift
//  Meet
//
//  Created by Derin Dutz on 11/13/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import Foundation
import Locksmith
import Parse

public class Account {
    
    // MARK: Public API
    
    /**
    Makes a request to Parse to log the user in. If the login is successful, the login information is stored in the keychain.
    
    - parameter username: The username of the user.
    - parameter password: The password of the user.
    
    - returns: Returns true on login success, false otherwise.
    */
    public class func login(username: String, password: String) -> Bool {
        let username = username.lowercaseString
        CurrentUser.username = username
        let login = try? PFUser.logInWithUsername(username, password: password)
        if login != nil {
            do {
                try Locksmith.saveData(["username": username, "password": password], forUserAccount: Constants.UserAccount)
            } catch _ {
                print("Error while saving login data.")
            }
            return true
        }
        return false
    }
    
    public class func signUp(username: String, password: String) {
        let username = username.lowercaseString
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        do {
            try newUser.signUp()
            let registeredUser = User()
            registeredUser.username = username
            registeredUser.isRegistered = true
            UserDatabase.updateUser(username, user: registeredUser)
            UserDatabase.saveUserToDatabase(username, user: UserDatabase.getUser(username)!)
            Account.login(username, password: password)
        } catch _ {
            print("Unable to sign up new user (\(username),\(password))")
        }
    }
    
    /**
     Attempts to used previously saved keychain values to login.
     
     - returns: Returns true on login success, false otherwise.
     */
    public class func loginWithKeychain() -> Bool {
        let dictionary = Locksmith.loadDataForUserAccount(Constants.UserAccount)
        if let userData = dictionary as? [String: String] {
            if let username = userData["username"]?.lowercaseString, password = userData["password"] {
                do {
                    try PFUser.logInWithUsername(username, password: password)
                    CurrentUser.username = username
                    return true
                } catch {
                    return false
                }
            }
        }
        return false
    }
    
    /**
     Logs the user out. Deletes any keychain data and logs the user out from Parse.
     */
    public class func logout() {
        do {
            try Locksmith.deleteDataForUserAccount(Constants.UserAccount)
        } catch _ {
            print("Error while logging out.")
        }
        PFUser.logOut()
    }
    
    /**
     Checks whether the user is logged in.
     
     - returns: Returns true if a user is logged in, false otherwise.
     */
    public class func isLoggedIn() -> Bool {
        return PFUser.currentUser() != nil
    }
    
    // MARK: Private Implementation
    
    // MARK: Constants
    
    private struct Constants {
        static let UserAccount = "MeetUserAccount"
    }
}

