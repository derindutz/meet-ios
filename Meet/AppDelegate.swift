//
//  AppDelegate.swift
//  Meet
//
//  Created by Derin Dutz on 11/13/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import Bolts
import Parse
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Enable storing and querying data from Local Datastore.
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("UtFM8kanKlQPPPjcFLuRpBTiR2758EXc5XH7qX8N",
            clientKey: "xZd3XnO1EqChkNMaoLMt1bZfg3VrMcQykr3ZdRv0")
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = MeetColor.LightestBackground
        pageControl.currentPageIndicatorTintColor = MeetColor.LightHighlight
        pageControl.backgroundColor = UIColor.whiteColor()
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barTintColor = UIColor.whiteColor()
        tabBarAppearance.translucent = false
        tabBarAppearance.backgroundImage = UIImage()
        tabBarAppearance.shadowImage = getImageWithColor(MeetColor.DarkBackground, size: CGSize(width: 1, height: 1))
        
        // Override point for customization after application launch.
        return true
    }
    
    private func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("loading meetings while entering foreground")
        if CurrentUser.username != "" {
            MeetingDatabase.loadMeetings()
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("terminating")
        Account.logout()
    }


}

