//
//  BaseNavigationController.swift
//  SinaWeibo
//
//  Created by baby on 15/8/17.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController,UINavigationControllerDelegate{
    
    var navDelegate: UIGestureRecognizerDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
        /**
        保存当前控制器的代理
        */
        navDelegate = self.interactivePopGestureRecognizer?.delegate
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /**
    show出来的控制器设置左右barButtonItem
    */
    override func showViewController(vc: UIViewController, sender: AnyObject?) {
            super.showViewController(vc, sender: sender)
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_more", highlightedImageName: "navigationbar_more_highlighted", target: self, action: "clickMoreButton", controllEvent: UIControlEvents.TouchUpInside)
            
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_back", highlightedImageName: "navigationbar_back_highlighted", target: self, action: "clickBackButton", controllEvent: UIControlEvents.TouchUpInside)
    }
    
    func clickMoreButton(){
        self.popToRootViewControllerAnimated(true)
    }
    
    func clickBackButton(){
        self.popViewControllerAnimated(true)
    }


    /**
    显示当前控制器时调用的代理方法
    */
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        /**
        *  如果是根控制器不清除代理，不是就清除代理
        */
        if viewController == self.viewControllers.first{
            self.interactivePopGestureRecognizer?.delegate = navDelegate
        }else{
            self.interactivePopGestureRecognizer?.delegate = nil
        }
    }
    
  
    

}
