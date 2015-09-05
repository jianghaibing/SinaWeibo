//
//  AppDelegate.swift
//  SinaWeibo
//
//  Created by baby on 15/8/8.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var audioPlayer:AVAudioPlayer!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        /**
        *  Icon的badgevalue
        */
        if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge, categories: nil)
            application.registerUserNotificationSettings(settings)
        } else {
            // Fallback on earlier versions
        }
        
        
        chooseRootViewController()
        
        //开启音频会话,使应用在真机上后台播放
        let avSession = AVAudioSession.sharedInstance()
        
        try! avSession.setCategory(AVAudioSessionCategoryPlayback)
        
        try! avSession.setActive(true)
       
        
        return true
    }
    
    private func chooseRootViewController(){
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        /// 取得当前版本号和上一次保存的版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
        let lastVersion = (NSUserDefaults.standardUserDefaults().objectForKey("Version") as? String) ?? "1.0.0"
        
        /**
        * 如果token过期了，进入认证界面
        * 如果当前版本号不等于上次保存的版本号或者第一次使用进入新特性界面
        * 否则进入主界面
        */
        if OauthTool.tokenIsExpire() {
            let vc3 = story.instantiateViewControllerWithIdentifier("oauth")
            window?.rootViewController = vc3
        }else if currentVersion != lastVersion || OauthTool.tokenIsNotExist() {
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
    
    
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        /**
        内存警告时停止下载并清除内存
        */
        SDWebImageManager.sharedManager().cancelAll()
        SDWebImageManager.sharedManager().imageCache.clearMemory()
    }

    func applicationWillResignActive(application: UIApplication) {
        
        //用后台播放音乐的方法使app一直在后台运行
        let URL = NSBundle.mainBundle().URLForResource("silence.mp3", withExtension: nil)
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: URL!)
        audioPlayer.prepareToPlay()
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        //开启后台任务
        application.beginBackgroundTaskWithExpirationHandler { () -> Void in
        }
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        audioPlayer.stop()
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Beijing-Gold-Finger-Education-Technology-LLC.HitList" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SinaWeibo", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SinaWeibo.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }


}

