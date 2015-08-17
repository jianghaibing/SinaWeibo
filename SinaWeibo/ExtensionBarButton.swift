//
//  ExtensionBarButton.swift
//  SinaWeibo
//
//  Created by baby on 15/8/9.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 创建自定义的导航栏UIBarbuttonItem
    static func createBarButtonItem(imageName:String,highlightedImageName:String,target:AnyObject?,action:Selector,controllEvent:UIControlEvents) -> UIBarButtonItem{
    
        let button = UIButton(type: UIButtonType.Custom)
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: highlightedImageName), forState: UIControlState.Highlighted)
        button.sizeToFit()
        button.addTarget(target, action: action, forControlEvents: controllEvent)
        return UIBarButtonItem(customView: button)
    }
    
}

