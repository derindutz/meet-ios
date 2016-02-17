//
//  AttendeePickerCell.swift
//  Meet
//
//  Created by Derin Dutz on 2/12/16.
//  Copyright © 2016 Derin Dutz. All rights reserved.
//

import UIKit

class AttendeePickerCell: UITableViewCell {
    
    var name: String? {
        didSet {
            updateUI()
        }
    }
    
    var isAttending = false {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkmarkView: UIImageView!
    
    // MARK: GUI
    
    private func updateUI() {
        self.nameLabel.text = name
        self.checkmarkView.hidden = !isAttending
    }
}
