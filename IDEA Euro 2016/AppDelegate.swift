//
//  AppDelegate.swift
//  IDEA Euro 2016
//
//  Created by Cuu Long Hoang on 5/26/16.
//  Copyright © 2016 Long Hoang. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        //UINavigationBar.appearance().backgroundColor = UIColor(red: 22/255, green: 131/255, blue: 198/255, alpha: 1)
//        UINavigationBar.appearance().setTra
        //UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        return true
    }

    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        if UIApplication.instancesRespondToSelector(#selector(UIApplication.registerUserNotificationSettings(_:))) {
            let notificationCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
            notificationCategory.identifier = "matchSchedule"
            
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert,.Badge,.Sound], categories: nil))
            
        }
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSNotificationCenter.defaultCenter().postNotificationName("alertMatch", object: nil)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if UIApplication.sharedApplication().applicationState == .Active {
            if let userInfo = notification.userInfo {
                let notification = userInfo["notification"] as! String
                let alert = UIAlertView(title: nil, message: notification, delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } 
        }
        
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

