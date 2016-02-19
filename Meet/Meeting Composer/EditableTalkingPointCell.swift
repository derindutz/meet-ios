//
//  EditableTalkingPointCell.swift
//  Meet
//
//  Created by Derin Dutz on 2/18/16.
//  Copyright © 2016 Derin Dutz. All rights reserved.
//

import UIKit

class EditableTalkingPointCell: UITableViewCell {
    
    // MARK: Public API
    
    var isEditingTalkingPoint = false {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var addTalkingPointIcon: UIImageView!
    @IBOutlet weak var addTalkingPointLabel: UILabel!
    
    @IBOutlet weak var talkingPointTextView: UITextView!
    
    // MARK: Private Implementation
    
    // MARK: GUI
    
    private func updateUI() {
        if self.isEditingTalkingPoint {
            addTalkingPointIcon.hidden = true
            addTalkingPointLabel.hidden = true
            talkingPointTextView.hidden = false
            talkingPointTextView.becomeFirstResponder()
        } else {
            addTalkingPointIcon.hidden = false
            addTalkingPointLabel.hidden = false
            talkingPointTextView.hidden = true
        }
    }
}

