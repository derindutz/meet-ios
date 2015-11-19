//
//  TalkingPointsTableViewCell.swift
//  Meet
//
//  Created by Derin Dutz on 11/15/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class TalkingPointsTableViewCell: UITableViewCell {
    
    // MARK: Public API
    
    var talkingPoint: String? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var talkingPointLabel: UILabel!
    
    // MARK: GUI
    
    private func updateUI() {
        talkingPointLabel.text = self.talkingPoint
    }
}

