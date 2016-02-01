//
//  UserProfileNameView.swift
//  Meet
//
//  Created by Derin Dutz on 11/27/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class UserProfileNameView: UIView {
    
    var user: User? {
        didSet {
            updateUI()
        }
    }
    
    private var profileView: UIView?
    private var nameLabel: UILabel?
    
    private func updateUI() {
        if let user = self.user {
            
            self.profileView?.removeFromSuperview()
            self.nameLabel?.removeFromSuperview()
            
            let imageDiameter: CGFloat = 50
            let imageX: CGFloat = (self.frame.width - imageDiameter) / 2.0
            let imageFrame = CGRectMake(imageX, 0, imageDiameter, imageDiameter)
            
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
                initialsView.font = UIFont.systemFontOfSize(20, weight: UIFontWeightLight)
                self.profileView = initialsView
            }
            
            self.profileView!.layer.cornerRadius = imageDiameter / 2.0
            self.profileView!.clipsToBounds = true
            self.addSubview(self.profileView!)
            
            let labelY: CGFloat = 53
            let labelFrame = CGRectMake(0, labelY, self.frame.width, self.frame.height - labelY)
            self.nameLabel = UILabel(frame: labelFrame)
            self.nameLabel!.textAlignment = NSTextAlignment.Center
            self.nameLabel!.text = user.firstNameLastInitial
            self.nameLabel!.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
            self.addSubview(self.nameLabel!)
        }
    }
}

