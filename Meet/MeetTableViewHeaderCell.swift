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
    
    @IBOutlet weak var headerLabel: UILabel!
    
    private func updateUI() {
        headerLabel.text = title
    }
    
}