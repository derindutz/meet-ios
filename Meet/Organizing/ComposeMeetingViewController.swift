//
//  ComposeMeetingViewController.swift
//  Meet
//
//  Created by Derin Dutz on 11/19/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class ComposeMeetingViewController: MeetViewController, UIPageViewControllerDataSource, UIGestureRecognizerDelegate {
    
    // TODO: remove edit button if not meeting host
    
    let pageIds = ["MeetingComposerInformationTableViewController", "TalkingPointsTableViewController", "AttendeesTableViewController", "MeetingComposerSummaryTableViewController"]
    
    var pageViewController: UIPageViewController!
    var meeting: Meeting = Meeting()
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ComposeMeetingPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let viewControllers = [viewControllerAtIndex(0)]
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        
        if let tabBar = self.tabBarController?.tabBar {
            self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.size.height + tabBar.frame.height)
        } else {
            self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.size.height)
        }
        
        self.pageViewController.view.backgroundColor = UIColor.whiteColor()
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    // MARK: Storyboard Connectivity
    
    private struct Constants {
        static let UnwindFromSavedMeeting = "Unwind From Saved Meeting"
    }
    
//    override func didMoveToParentViewController(parent: UIViewController?) {
//        if (!(parent?.isEqual(self.parentViewController) ?? false)) {
//            self.meeting.save()
//        }
//    }
    
    @IBAction func cancelComposeMeeting(sender: UIBarButtonItem) {
        let alert = UIAlertController()
        
        alert.addAction(UIAlertAction(
            title: "Delete Draft",
            style: .Destructive)
            { (action: UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        
        alert.addAction(UIAlertAction(
            title: "Save Draft",
            style: .Default)
            { (action: UIAlertAction) -> Void in
                self.meeting.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .Cancel)
            { (action: UIAlertAction) -> Void in
                // do nothing
            }
        )
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        if identifier == Constants.UnwindFromSavedMeeting {
//            return self.meeting.save()
//        }
//        
//        return false
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("preparing for segue")
        if let identifier = segue.identifier {
            if identifier == Constants.UnwindFromSavedMeeting {
                if let currentVC = self.pageViewController.viewControllers![0] as? MeetingComposerTableViewController {
                    currentVC.saveModel()
                    if let otvc = segue.destinationViewController as? OrganizingTableViewController {
                        otvc.meetings = MeetingDatabase.getOrganizingMeetings()
                        print("updated meetings")
                    }
                }
            }
        }
    }
    
    // MARK: Page View Controller Methods
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! MeetingComposerTableViewController
        var index = vc.pageIndex as Int
        
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! MeetingComposerTableViewController
        var index = vc.pageIndex as Int
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if index == pageIds.count {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    private func viewControllerAtIndex(index: Int) -> UIViewController {
        switch index {
        case 0:
            let informationVC = self.storyboard?.instantiateViewControllerWithIdentifier(pageIds[index]) as! MeetingComposerInformationTableViewController
            informationVC.meeting = self.meeting
            informationVC.pageIndex = index
            informationVC.meetingDataSource = self
            return informationVC
        case 1:
            let talkingPointsVC = self.storyboard?.instantiateViewControllerWithIdentifier(pageIds[index]) as! TalkingPointsTableViewController
            talkingPointsVC.meeting = self.meeting
            talkingPointsVC.pageIndex = index
            talkingPointsVC.meetingDataSource = self
            return talkingPointsVC
        case 2:
            let attendeesVC = self.storyboard?.instantiateViewControllerWithIdentifier(pageIds[index]) as! AttendeesTableViewController
            attendeesVC.meeting = self.meeting
            attendeesVC.pageIndex = index
            attendeesVC.meetingDataSource = self
            return attendeesVC
        case 3:
            let summaryVC = self.storyboard?.instantiateViewControllerWithIdentifier(pageIds[index]) as! MeetingComposerSummaryTableViewController
            summaryVC.meeting = self.meeting
            summaryVC.pageIndex = index
            summaryVC.meetingDataSource = self
            return summaryVC
        default:
            return UIViewController()
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageIds.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
