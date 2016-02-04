//
//  UserScrollView.swift
//  Meet
//
//  Created by Derin Dutz on 11/27/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class UserScrollView: UIScrollView {
    
    var actionDelegate: MeetingComposerSummaryTableViewController? {
        didSet {
            updateUI()
        }
    }
    
    var is_add_enabled = false {
        didSet {
            updateUI()
        }
    }
    
    var users: [String]? {
        didSet {
            updateUI()
        }
    }
    
    private enum ObjectType {
        case User
        case AddUserButton
    }
    
    private func updateUI() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        var objects = [(ObjectType, String)]()
        
        if is_add_enabled {
            objects.append((ObjectType.AddUserButton, "add"))
        }

        if let users = self.users {
            for username in users {
                objects.append((ObjectType.User, username))
            }
        }
        
        let frameHeight: CGFloat = 100
        let userViewWidth: CGFloat = 90
        let userViewHeight: CGFloat = 72
        let userViewSpacing: CGFloat = 10
        let userViewY: CGFloat = (frameHeight - userViewHeight) / 2.0
        
        let userViewsWidth: CGFloat = (userViewWidth * CGFloat(objects.count)) + (userViewSpacing * CGFloat(objects.count - 1))
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let userViewXOffset: CGFloat = objects.count < 3 ? ((screenWidth - userViewsWidth) / 2.0) : 42
        
        let frameWidth: CGFloat = (userViewXOffset * 2.0) + userViewsWidth
        
        for (index, type_name_pair) in objects.enumerate() {
            let frameX = userViewXOffset + (CGFloat(index) * (userViewWidth + userViewSpacing))
            let frame = CGRect(x: frameX, y: userViewY, width: userViewWidth, height: userViewHeight)
        
            let type = type_name_pair.0
            switch(type) {
            case .User:
                let view = UserProfileNameView(frame: frame)
                let username = type_name_pair.1
                if let user = UserDatabase.getUser(username) {
                    view.user = user
                }
                self.addSubview(view)
            case .AddUserButton:
                let button = AddUserButton(frame: frame)
                if let actionDelegate = self.actionDelegate {
                    button.addTarget(actionDelegate, action: "addUser:", forControlEvents: UIControlEvents.TouchUpInside)
                }
                self.addSubview(button)
            }            
        }
        
        self.contentSize = CGSizeMake(frameWidth, frameHeight);
    }
}
