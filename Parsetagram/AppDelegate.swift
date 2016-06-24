//
//  AppDelegate.swift
//  Parsetagram
//
//  Created by Udgam Goyal on 6/19/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var alertController: UIAlertController!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "Parsetagram"
                configuration.clientKey = "sdkz.fuhszdkxj.hfs.kzdjx,fhsukd.jf"  // set to nil assuming you have not set clientKey
                configuration.server = "https://sleepy-meadow-69682.herokuapp.com/parse"
            })
        )
        
        if PFUser.currentUser() != nil{
            print("User is back")
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewControllerWithIdentifier("mainTabBarController") as! UITabBarController
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            
        }
        
        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let homeNavigationController = storyboard.instantiateViewControllerWithIdentifier("HomeNavigationController") as! UINavigationController
//        let homeViewController = homeNavigationController.topViewController as! HomeViewController
//        homeViewController.feed = "home"
//        homeNavigationController.tabBarItem.title = "News Feed"
//        homeNavigationController.tabBarItem.image = UIImage(named: "feed")
//        
//        let profileNavigationController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as! UINavigationController
//        let profileViewController = profileNavigationController.topViewController as! HomeViewController
//        profileViewController.feed = "profile"
//        profileNavigationController.tabBarItem.title = "Profile"
//        profileNavigationController.tabBarItem.image = UIImage(named: "profile")
//        
//        
//        let tabBarController = UITabBarController()
//        
//        tabBarController.viewControllers = [homeNavigationController, profileNavigationController]
//        
//        window?.rootViewController = tabBarController
//        window?.makeKeyAndVisible()
        
        return true
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
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

