//
//  MainTabBarController.swift
//  SinaWeibo
//
//  Created by baby on 15/8/8.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit



class MainTabBarController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        /// 用自定义的tabbar替换系统的tabbar
        let customTabBar = CustomTabBar()
        /**
        利用KVC修改readonly的属性
        :param: forKeyPath 需要替换的属性“tabbar”
        */
        self.setValue(customTabBar, forKeyPath: "tabBar")
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
