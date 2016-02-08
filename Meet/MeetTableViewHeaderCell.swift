//
//  MeetTableViewHeaderCell.swift
//  Meet
//
//  Created by Derin Dutz on 11/19/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetTableViewHeaderCell: UITableViewCell {
    
    var title: String? {
        didSet {
            updateUI()
        }
    }
    
    var showNotification = false {
        didSet {
            updateNotification()
        }
    }
    
    var notificationImageView: UIImageView?
    
    @IBOutlet weak var headerLabel: UILabel!
    
    private func updateUI() {
        headerLabel.text = title
    }
    
    override func layoutSubviews() {
        print(self.contentView.bounds.width)
        print(self.contentView.frame.width)
        print(self.contentView.bounds.origin.x)
        print(self.contentView.frame.origin.x)
        print(self.contentView.frame.size.width)
        print(self.headerLabel.center.y)
    }
    
    private func updateNotification() {
        if self.notificationImageView == nil {
            let notificationIconImage = UIImage(named: "header_notification_icon")
            let screenWidth = UIScreen.mainScreen().bounds.width
            let notificationImageView = UIImageView(frame: CGRectMake(screenWidth - 30, self.headerLabel.center.y - 5, 10, 10))
            notificationImageView.image = notificationIconImage
            self.contentView.addSubview(notificationImageView)
            self.notificationImageView = notificationImageView
        }
        self.notificationImageView!.hidden = !self.showNotification
    }
    
}