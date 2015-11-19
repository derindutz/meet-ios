//
//  MeetNavigationController.swift
//  Meet
//
//  Created by Derin Dutz on 11/17/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetNavigationController: UINavigationController {
    
    private struct Constants {
        static let NavBarColor = UIColor(red: CGFloat(44/255.0), green: CGFloat(62/255.0), blue: CGFloat(80/255.0), alpha: 1.0)
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = Constants.NavBarColor
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationBar.tintColor = UIColor.whiteColor()
        
        let logo = UIImage(named: "logo")
        self.navigationItem.titleView = UIImageView(image: logo)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
