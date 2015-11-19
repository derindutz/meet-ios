//
//  MeetTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/18/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetTableViewController: UITableViewController {
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "logo")
        self.navigationItem.titleView = UIImageView(image: logo)
    }
}