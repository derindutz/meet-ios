//
//  TalkingPointWithProfilesCell.swift
//  Meet
//
//  Created by Derin Dutz on 12/2/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class TalkingPointWithProfilesCell: UITableViewCell {
    
    // MARK: Public API
    
    var talkingPoint: TalkingPoint? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var textWithProfilesView: LabelAboveViewView!
    
    // MARK: GUI
    
    class func getHeight(talkingPoint: TalkingPoint) -> CGFloat {
        let label = UILabel()
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        label.text = talkingPoint.text
        label.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        let screenWidth = UIScreen.mainScreen().bounds.width
        label.frame = CGRectMake(0, 0, screenWidth - 97, 0)
        label.sizeToFit()
        
        if !talkingPoint.relevantUsers.isEmpty {
            return label.bounds.height + 25 + 40
        }
        
        return label.bounds.height + 40
    }
    
    private func updateUI() {
        if let point = self.talkingPoint, view = self.textWithProfilesView {
            let label = UILabel()
            label.lineBreakMode = .ByWordWrapping
            label.numberOfLines = 0
            label.text = point.text
            label.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
            let screenWidth = UIScreen.mainScreen().bounds.width
            label.frame = CGRectMake(0, 0, screenWidth - 97, 0)
            label.sizeToFit()
            
            view.topLabel = label
            
            if !point.relevantUsers.isEmpty {
                let profilesView = HorizontalProfilesView()
                profilesView.users = point.relevantUsers
                view.bottomView = profilesView
            }
            
            view.sizeToFit()
        }
    }
}

