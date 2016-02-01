//
//  MeetingComposerSummarySendCell.swift
//  Meet
//
//  Created by Derin Dutz on 11/29/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetingComposerSummarySendCell: UITableViewCell {
    
    // MARK: Public API
    
    var isSendEnabled: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.setImage(UIImage(named: "paper_airplane"), forState: .Normal)
            sendButton.setImage(UIImage(named: "paper_airplane_grey"), forState: .Disabled)
            updateUI()
        }
    }
    
    // MARK: GUI
    
    private func updateUI() {
        sendButton.enabled = self.isSendEnabled
    }
}
