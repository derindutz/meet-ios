//
//  ProfileView.swift
//  Meet
//
//  Created by Derin Dutz on 12/2/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    var diameter: CGFloat = 50 {
        didSet {
            updateUI()
        }
    }
    
    var fontSize: CGFloat = 20 {
        didSet {
            updateUI()
        }
    }
    
    var user: User? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        self.profileView?.removeFromSuperview()
        if let user = self.user {
            let imageX: CGFloat = (self.frame.width - self.diameter) / 2.0
            let imageFrame = CGRectMake(imageX, 0, self.diameter, self.diameter)
            
            if let profileData = user.getProfileImage() {
                let profileImageView = UIImageView(frame: imageFrame)
                profileImageView.image = profileData
                self.profileView = profileImageView
            } else {
                let initialsView = UILabel(frame: imageFrame)
                initialsView.backgroundColor = MeetColor.DarkHighlight
                initialsView.text = user.initials
                initialsView.textColor = UIColor.whiteColor()
                initialsView.textAlignment = NSTextAlignment.Center
                initialsView.font = UIFont.systemFontOfSize(self.fontSize, weight: UIFontWeightLight)
                self.profileView = initialsView
            }
            
            self.profileView!.layer.cornerRadius = self.diameter / 2.0
            self.profileView!.clipsToBounds = true
            self.addSubview(self.profileView!)
        }
    }
    
    private var profileView: UIView?
}

