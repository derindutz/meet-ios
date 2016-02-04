//
//  LoginViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/13/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: MeetViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileView: ProfileView! {
        didSet {
            profileView.diameter = 100
        }
    }
    
    @IBOutlet weak var actionButton: UIButton!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidden = true
        activityIndicator.center = self.view.center
        
        
        nameTextField.delegate = self
        nameTextField.becomeFirstResponder()
    }
    
    var timer: NSTimer? = nil
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("getHints:"), userInfo: textField, repeats: false)
        return true
    }
    
    func getHints(timer: NSTimer) {
        updateUser()
    }
    
    override func viewDidAppear(animated: Bool) {
        attemptLoginWithKeychain()
    }
    
    // MARK: Text Field Delegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        updateUser()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: Storyboard Connectivity
    
    private struct Constants {
        static let SegueLogin = "Login"
        static let LoginString = "log in"
        static let SignUpString = "sign up"
        static let GetStartedString = "get started"
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Constants.SegueLogin {
            return Account.isLoggedIn()
        }
        return true
    }
    
    private var user: User? {
        didSet {
            if self.user == nil {
                let questionUser = User()
                questionUser.firstName = "?"
                profileView.user = questionUser
            } else {
                profileView.user = self.user
            }
        }
    }
    
    private func updateUser() {
        if let name = nameTextField.text {
            self.user = AddressBookHelper.getUserByName(name)
        } else {
            self.user = nil
        }
    }
    
    @IBAction func loginPressed(sender: UIButton) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        updateUser()
        if self.user != nil {
            attemptLoginWithKeychain()
        } else {
            AddressBookHelper.showMessage("No contacts were found matching the given name.")
        }
    }
    
    // MARK: Login
    
    private func attemptLoginWithKeychain() {
        if Account.loginWithKeychain() {
            print("Logged in with keychain.")
            performLogin()
        } else {
            if let user = self.user, username = user.username {
                if Account.login(username, password: "password") {
                    print("Logged in with password.")
                    performLogin()
                } else {
                    createNewAccount(username, password: "password")
                    CurrentUser.username = username
                    performLogin()
                }
            }
        }
    }
    
    private func performLogin() {
        print("performing login...")
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        MeetingDatabase.loadMeetings()
        performSegueWithIdentifier(Constants.SegueLogin, sender: self)
    }
    
    private func createNewAccount(username: String, password: String) {
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