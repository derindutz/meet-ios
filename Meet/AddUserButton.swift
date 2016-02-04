//
//  AddUserButton.swift
//  Meet
//
//  Created by Derin Dutz on 2/3/16.
//  Copyright © 2016 Derin Dutz. All rights reserved.
//

import UIKit

class AddUserButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createButton() {
        let backgroundDiameter: CGFloat = 50
        let backgroundX: CGFloat = (self.frame.width - backgroundDiameter) / 2.0
        let backgroundY: CGFloat = 0
        let backgroundFrame = CGRectMake(backgroundX, backgroundY, backgroundDiameter, backgroundDiameter)
        
        let backgroundView = UIView(frame: backgroundFrame)
        backgroundView.backgroundColor = MeetColor.DarkHighlight
        backgroundView.layer.cornerRadius = backgroundDiameter / 2.0
        backgroundView.clipsToBounds = true
        backgroundView.userInteractionEnabled = false
        backgroundView.exclusiveTouch = false
        self.addSubview(backgroundView)
        
        let imageWidth: CGFloat = 20
        let imageHeight = imageWidth
        let imageX: CGFloat = (self.frame.width - imageWidth) / 2.0
        let imageY: CGFloat = ((backgroundY + backgroundDiameter) - imageHeight) / 2.0
        let imageFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight)
        
        let imageView = UIImageView(frame: imageFrame)
        imageView.image = UIImage(named: "plus_icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageView.tintColor = UIColor.whiteColor()
        imageView.userInteractionEnabled = false
        imageView.exclusiveTouch = false
        self.addSubview(imageView)
        
        let labelY: CGFloat = 53
        let labelFrame = CGRectMake(0, labelY, self.frame.width, self.frame.height - labelY)
        let label = UILabel(frame: labelFrame)
        label.textAlignment = NSTextAlignment.Center
        label.text = "add attendee"
        label.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        label.userInteractionEnabled = false
        label.exclusiveTouch = false
        self.addSubview(label)
        
                    
//            self.profileView?.removeFromSuperview()
//            self.nameLabel?.removeFromSuperview()
//            
//            
//            
//            if let profileData = user.getProfileImage() {
//                let profileImageView = UIImageView(frame: imageFrame)
//                profileImageView.image = profileData
//                self.profileView = profileImageView
//            } else {
//                let initialsView = UILabel(frame: imageFrame)
//                initialsView.backgroundColor = MeetColor.DarkHighlight
//                initialsView.text = user.initials
//                initialsView.textColor = UIColor.whiteColor()
//                initialsView.textAlignment = NSTextAlignment.Center
//                initialsView.font = UIFont.systemFontOfSize(20, weight: UIFontWeightLight)
//                self.profileView = initialsView
//            }
        
//            self.profileView!.layer.cornerRadius = imageDiameter / 2.0
//            self.profileView!.clipsToBounds = true
//            self.addSubview(self.profileView!)
//            
//            let labelY: CGFloat = 53
//            let labelFrame = CGRectMake(0, labelY, self.frame.width, self.frame.height - labelY)
//            self.nameLabel = UILabel(frame: labelFrame)
//            self.nameLabel!.textAlignment = NSTextAlignment.Center
//            self.nameLabel!.text = user.firstNameLastInitial
//            self.nameLabel!.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
//            self.addSubview(self.nameLabel!)
    }
}
