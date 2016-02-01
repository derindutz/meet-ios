//
//  UserScrollView.swift
//  Meet
//
//  Created by Derin Dutz on 11/27/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class UserScrollView: UIScrollView {
    
    var users: [String]? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        print("views: \(self.subviews)")
        print("count: \(self.subviews.count)")
        for view in self.subviews {
            view.removeFromSuperview()
        }
        print("updated views: \(self.subviews)")
        print("updated count: \(self.subviews.count)")
        
        if let users = self.users {
            let frameHeight: CGFloat = 100
            let userViewWidth: CGFloat = 90
            let userViewHeight: CGFloat = 72
            let userViewSpacing: CGFloat = 10
            let userViewY: CGFloat = (frameHeight - userViewHeight) / 2.0
            
            let userViewsWidth: CGFloat = (userViewWidth * CGFloat(users.count)) + (userViewSpacing * CGFloat(users.count - 1))
            
            let screenWidth = UIScreen.mainScreen().bounds.width
            let userViewXOffset: CGFloat = users.count < 3 ? ((screenWidth - userViewsWidth) / 2.0) : 42
            
            let frameWidth: CGFloat = (userViewXOffset * 2.0) + userViewsWidth
            
            for (index, username) in users.enumerate() {
                let frameX = userViewXOffset + (CGFloat(index) * (userViewWidth + userViewSpacing))
                let frame = CGRect(x: frameX, y: userViewY, width: userViewWidth, height: userViewHeight)
                let view = UserProfileNameView(frame: frame)
            
                if let user = UserDatabase.getUser(username) {
                    view.user = user
                }
                self.addSubview(view)
            }
            
            self.contentSize = CGSizeMake(frameWidth, frameHeight);
        }
    }
}
