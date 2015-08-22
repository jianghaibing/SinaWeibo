//
//  AppDelegate.swift
//  SinaWeibo
//
//  Created by baby on 15/8/8.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        chooseRootViewController()
        
        return true
    }
    
    private func chooseRootViewController(){
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        /// 取得当前版本号和上一次保存的版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
        let lastVersion = (NSUserDefaults.standardUserDefaults().objectForKey("Version") as? String) ?? "1.0.0"
        
        /// 从数据库取用户数据
        let db = NyaruDB.instance()
        let collection = db.collection("User")
        let documents = collection.all().fetch()
        var expireDate:NSDate?
        if documents.count > 0 {
            /// 获取过期时间
            expireDate = NSDate(timeInterval: documents[0]["expires_in"] as! NSTimeInterval , sinceDate: documents[0]["date"] as! NSDate)
        }else{
            expireDate = NSDate(timeIntervalSinceNow: -100)
        }
        /**
        * 如果token过期了或第一次使用，进入认证界面
        * 如果当前版本号不等于上次保存的版本号进入新特性界面
        * 否则进入主界面
        */
        if NSDate().compare(expireDate!) != NSComparisonResult.OrderedAscending || documents.count == 0 {
            let vc3 = story.instantiateViewControllerWithIdentifier("oauth")
            window?.rootViewController = vc3
        }else if currentVersion != lastVersion {
            let vc1 = story.instantiateViewControllerWithIdentifier("newfeature")
            window?.rootViewController = vc1
        }else{
            let vc2 = story.instantiateViewControllerWithIdentifier("maintabbar")
            window?.rootViewController = vc2
        }
        /**
        保存当前的版本号
        */
        NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "Version")

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

