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
    
    var talkingPoint: TalkingPoint? {
        didSet {
            updateUI()
        }
    }
    
    var row: Int?
    var delegate: TalkingPointsTableViewController?
    
    // MARK: Outlets
    
    @IBOutlet weak var talkingPointLabel: UILabel!
    
    @IBAction func removeTalkingPoint(sender: UIButton) {
        if let delegate = self.delegate, row = self.row {
            delegate.removeTalkingPoint(row)
        }
    }
    
    // MARK: GUI
    
    private func updateUI() {
        talkingPointLabel.text = nil
        if let talkingPoint = self.talkingPoint {
            talkingPointLabel.text = talkingPoint.text
        }
    }
}

