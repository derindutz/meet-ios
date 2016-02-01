//
//  HorizontalProfilesView.swift
//  Meet
//
//  Created by Derin Dutz on 12/2/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class HorizontalProfilesView: UIView {
    
    var users: [String]? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let users = self.users {
            
            let frameHeight: CGFloat = 20
            let userViewWidth: CGFloat = 20
            let userViewHeight: CGFloat = 20
            let userViewSpacing: CGFloat = 5
            
            let userViewY: CGFloat = (frameHeight - userViewHeight) / 2.0
            let userViewsWidth: CGFloat = (userViewWidth * CGFloat(users.count)) + (userViewSpacing * CGFloat(users.count - 1))
            
            let userViewXOffset: CGFloat = 0
            
            let frameWidth: CGFloat = (userViewXOffset * 2.0) + userViewsWidth
            
            for (index, username) in users.enumerate() {
                let frameX = userViewXOffset + (CGFloat(index) * (userViewWidth + userViewSpacing))
                let frame = CGRect(x: frameX, y: userViewY, width: userViewWidth, height: userViewHeight)
                let profileView = ProfileView(frame: frame)
                profileView.diameter = 20
                profileView.fontSize = 8
                if let user = UserDatabase.getUser(username) {
                    profileView.user = user
                }
                self.addSubview(profileView)
            }
            
            self.sizeToFit()
        }
    }
}

