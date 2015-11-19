//
//  LoginViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/13/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        attemptLoginWithKeychain()
    }
    
    // MARK: Storyboard Connectivity
    
    private struct Storyboard {
        static let SegueLogin = "Login"
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.SegueLogin {
            return Account.isLoggedIn()
        }
        return true
    }
    
    // MARK: Login
    
    private func attemptLoginWithKeychain() {
        if Account.loginWithKeychain() {
            print("Logged in with keychain.")
            performLogin()
        } else {
            if Account.login("admin", password: "pass") {
                print("Logged in with password.")
            } else {
                createNewAccount()
            }
        }
    }
    
    private func performLogin() {
        print("performing login...")
        performSegueWithIdentifier(Storyboard.SegueLogin, sender: self)
    }
    
    private func createNewAccount() {
        let username = "admin"
        let password = "pass"
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        do {
            try newUser.signUp()
            Account.login(username, password: password)
            print("Created new account (\(username),\(password))")
        } catch _ {
            print("Unable to sign up new user (\(username),\(password))")
        }
    }
}

// MARK: - Convenience Extensions

extension UIViewController {
    var contentViewController: UIViewController {
        if let tabcon = self as? UITabBarController {
            if let vc = tabcon.viewControllers?.first as UIViewController! {
                return vc
            }
        } else if let navcon = self as? UINavigationController {
            return navcon.visibleViewController!
        }
        return self
    }
}