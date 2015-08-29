//
//  AppDelegate.swift
//  SinaWeibo
//
//  Created by baby on 15/8/8.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit
import AVFoundation

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
        do {
            try avSession.setCategory(AVAudioSessionCategoryPlayback)
        }catch{
            print("session设置错误")
        }
        
        do {
            try avSession.setActive(true)
        }catch{
            print("激活错误")
        }
        
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
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: URL!)
        }catch {
            fatalError("播放错误")
        }
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
    }


}

