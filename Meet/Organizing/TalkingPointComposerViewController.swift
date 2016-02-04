//
//  TalkingPointComposerViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/15/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class TalkingPointComposerViewController: MeetViewController, UITextViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = Constants.Placeholder
        textView.textColor = Constants.PlaceholderColor
        
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
        textView.delegate = self
    }
    
    // MARK: Storyboard Connectivity
    
    private struct Storyboard {
        static let UnwindFromNewlyCreatedTalkingPoint = "Unwind From Newly Created Talking Point"
        static let CancelComposeTalkingPoint = "Cancel Compose Talking Point"
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.CancelComposeTalkingPoint {
            return true
        }
        
        if identifier == Storyboard.UnwindFromNewlyCreatedTalkingPoint {
            return textView.textColor == Constants.TextColor && !textView.text.isEmpty && textView.text.utf16.count <= Constants.MaxCharacterCount
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Storyboard.UnwindFromNewlyCreatedTalkingPoint {
                if let mcstvc = segue.destinationViewController as? MeetingComposerSummaryTableViewController {
                    mcstvc.meeting.talkingPoints.append(TalkingPoint(text: textView.text))
                }
            }
        }
    }
    
    // MARK: Text View Delegate
    
    private struct Constants {
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
            characterCountLabel.text = "\(numCharactersLeft) characters left"
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.text = Constants.Placeholder
            textView.textColor = Constants.PlaceholderColor
            characterCountLabel.text = "\(Constants.MaxCharacterCount) characters left"
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        } else if textView.textColor == Constants.PlaceholderColor && !text.isEmpty {
            textView.text = nil
            textView.textColor = Constants.TextColor
        }
        
        return true
    }
}
