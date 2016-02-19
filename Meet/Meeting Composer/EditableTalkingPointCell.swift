//
//  EditableTalkingPointCell.swift
//  Meet
//
//  Created by Derin Dutz on 2/18/16.
//  Copyright © 2016 Derin Dutz. All rights reserved.
//

import UIKit

class EditableTalkingPointCell: UITableViewCell, UITextViewDelegate {
    
    // MARK: Public API
    
    var delegate: MeetingComposerSummaryTableViewController?
    
    var talkingPoint: TalkingPoint? {
        didSet {
            updateUI()
        }
    }
    
    var isEditingTalkingPoint = false {
        didSet {
            updateUI()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var addTalkingPointIcon: UIImageView!
    @IBOutlet weak var addTalkingPointLabel: UILabel!
    
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var charactersLeftLabel: UILabel!
    @IBOutlet weak var talkingPointTextView: UITextView! {
        didSet {
            talkingPointTextView.textContainer.lineFragmentPadding = 0
            talkingPointTextView.returnKeyType = .Done
        }
    }
    
    // MARK: Private Implementation
    
    // MARK: GUI
    
    private func updateUI() {
        if self.isEditingTalkingPoint {
            addTalkingPointIcon.hidden = true
            addTalkingPointLabel.hidden = true
            talkingPointTextView.hidden = false
            
            if let talkingPoint = self.talkingPoint {
                talkingPointTextView.text = talkingPoint.text
                talkingPointTextView.textColor = Constants.TextColor
            } else {
                talkingPointTextView.text = Constants.Placeholder
                talkingPointTextView.textColor = Constants.PlaceholderColor
                talkingPointTextView.selectedTextRange = talkingPointTextView.textRangeFromPosition(talkingPointTextView.beginningOfDocument, toPosition: talkingPointTextView.beginningOfDocument)
            }
            talkingPointTextView.becomeFirstResponder()
            talkingPointTextView.delegate = self
            
            separatorView.hidden = false
            charactersLeftLabel.hidden = false
        } else {
            addTalkingPointLabel.hidden = false
            talkingPointTextView.hidden = true
            charactersLeftLabel.hidden = true
            
            if let talkingPoint = self.talkingPoint {
                addTalkingPointLabel.text = talkingPoint.text
                addTalkingPointLabel.textColor = Constants.TextColor
                addTalkingPointIcon.hidden = true
                separatorView.hidden = false
            } else {
                addTalkingPointLabel.text = Constants.AddTalkingPointText
                addTalkingPointLabel.textColor = Constants.PlaceholderColor
                addTalkingPointIcon.hidden = false
                separatorView.hidden = true
            }
        }
    }
    
    // MARK: Text View Delegate
    
    private struct Constants {
        static let AddTalkingPointText = "add talking point"
        static let Placeholder = "Example: Coordinate flight logistics for everyone on the Seattle trip next Tuesday."
        static let PlaceholderColor = UIColor(red: CGFloat(210/255.0), green: CGFloat(215/255.0), blue: CGFloat(220/255.0), alpha: 1.0)
        static let TextColor = UIColor.blackColor()
        static let MaxCharacterCount = 150
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.textColor == Constants.TextColor {
            var numCharactersLeft = Constants.MaxCharacterCount - textView.text.utf16.count
            if numCharactersLeft < 0 {
                textView.text = textView.text.substringToIndex(textView.text.startIndex.advancedBy(Constants.MaxCharacterCount))
                numCharactersLeft = Constants.MaxCharacterCount - textView.text.utf16.count
            }
            charactersLeftLabel.text = "\(numCharactersLeft) characters left"
        }
    }
    
    func doneEditing() {
        if self.isEditingTalkingPoint {
            talkingPointTextView.resignFirstResponder()
            self.isEditingTalkingPoint = false
            if talkingPointTextView.textColor == Constants.TextColor && !talkingPointTextView.text.isEmpty && talkingPointTextView.text.utf16.count <= Constants.MaxCharacterCount {
                if self.talkingPoint != nil {
                    self.talkingPoint?.text = talkingPointTextView.text
                    delegate?.talkingPointUpdated()
                } else {
                    delegate?.talkingPointComposed(TalkingPoint(text: talkingPointTextView.text))
                }
            } else {
                delegate?.talkingPointCancelled()
            }
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        doneEditing()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            talkingPointTextView.resignFirstResponder()
            return true
        }
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.text = Constants.Placeholder
            textView.textColor = Constants.PlaceholderColor
            charactersLeftLabel.text = "\(Constants.MaxCharacterCount) characters left"
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        } else if textView.textColor == Constants.PlaceholderColor && !text.isEmpty {
            textView.text = nil
            textView.textColor = Constants.TextColor
        }
        
        return true
    }
}

