//
//  LoadingViewController.swift
//  Meet
//
//  Created by Derin Dutz on 2/7/16.
//  Copyright © 2016 Derin Dutz. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UserDatabase.load()
        AddressBookHelper.getUsers()
        if Account.loginWithKeychain() {
            MeetingDatabase.loadMeetings()
            performSegueWithIdentifier(Constants.SegueDashboard, sender: self)
        } else {
            performSegueWithIdentifier(Constants.SegueLogin, sender: self)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Constants.SegueLogin {
            return Account.isLoggedIn()
        }
        return true
    }
    
    // MARK: Constants
    
    private struct Constants {
        static let SegueDashboard = "SegueDashboard"
        static let SegueLogin = "SegueLogin"
    }
}
