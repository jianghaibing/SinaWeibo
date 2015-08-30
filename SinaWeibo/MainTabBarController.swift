//
//  MainTabBarController.swift
//  SinaWeibo
//
//  Created by baby on 15/8/8.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit



class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var lastSelectVC:UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        /// 用自定义的tabbar替换系统的tabbar
        let customTabBar = CustomTabBar()
        /**
        利用KVC修改readonly的属性
        :param: forKeyPath 需要替换的属性“tabbar”
        */
        self.setValue(customTabBar, forKeyPath: "tabBar")
        
        /// 创建发布按钮
        let publishButton = customTabBar.createAddButton()
        publishButton.addTarget(self, action: "publishWeibo", forControlEvents: UIControlEvents.TouchUpInside)
        
        delegate = self
        lastSelectVC = self.childViewControllers[0] as? BaseNavigationController//记录上次选中的控制器
        NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: "requestUnreadCount", userInfo: nil, repeats: true)
        
    }
    
    
    func requestUnreadCount(){
        /**
        *  设置tabbarItem的未读数
        */
        UserTool.getUnreadCount({ (result:UnreadResultParam) -> Void in
            
            for (index,VC) in self.childViewControllers.enumerate() {
                switch index{
                case 0:
                    VC.tabBarItem.badgeValue = String(result.status!)
                case 1:
                    VC.tabBarItem.badgeValue = String(result.getUnreadMessageCount())
                case 3:
                    VC.tabBarItem.badgeValue = String(result.follower!)
                default:
                    self.tabBar.layoutSubviews()//更新数值后重新layout一下tabbar
                }
            }
            
            UIApplication.sharedApplication().applicationIconBadgeNumber = result.getTotalUnreadCount()
            
            }) { (error) -> Void in
                print(error)
        }

    }
    
    
    func publishWeibo(){
        print("发布微博")
    }
    
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        /**
        *  如果选中的控制器是第一个控制器并且上次选中的控制器和本次选中一样是，调用刷新方法
        */
        if lastSelectVC == viewController && viewController == self.childViewControllers[0] as? BaseNavigationController {
            (self.childViewControllers[0].childViewControllers[0] as? HomeTableViewController)!.refresh()
        }
        lastSelectVC = viewController
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
