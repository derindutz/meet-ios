//
//  MeetingSectionNullStateCell.swift
//  Meet
//
//  Created by Derin Dutz on 11/29/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class MeetingSectionNullStateCell: UITableViewCell {
    
    // MARK: Public API
    
    var nullStateText: String? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var nullStateTextLabel: UILabel!
    
    // MARK: GUI
    
    private func updateUI() {
        nullStateTextLabel.text = nil
        if let nullStateText = self.nullStateText {
            nullStateTextLabel.text = nullStateText
        }
    }
}
