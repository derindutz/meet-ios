//
//  TalkingPointSummaryTableViewController.swift
//  Meet
//
//  Created by Derin Dutz on 12/2/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class TalkingPointSummaryTableViewController: MeetTableViewController {
    
    // MARK: Public API
    
    var talkingPoint: TalkingPoint? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var talkingPointLabel: UILabel! {
        didSet {
            updateLabel()
        }
    }
    @IBOutlet weak var relevantUsersView: UserScrollView! {
        didSet {
            updateRelevantUsers()
        }
    }
    @IBOutlet weak var relevantUsersLabel: UILabel! {
        didSet {
            updateRelevantUsers()
        }
    }
    
    
    // MARK: GUI
    
    private func updateUI() {
        updateLabel()
        updateRelevantUsers()
    }
    
    private func updateLabel() {
        if let text = self.talkingPoint?.text, label = self.talkingPointLabel {
            print("talking point text: \(text)")
            label.text = text
        }
    }
    
    private func updateRelevantUsers() {
        if let label = relevantUsersLabel {
            label.hidden = false
            if let view = relevantUsersView, relevantUsers = talkingPoint?.relevantUsers {
                if !relevantUsers.isEmpty {
                    view.users = relevantUsers
                    label.hidden = true
                }
            }
        }
    }
}
