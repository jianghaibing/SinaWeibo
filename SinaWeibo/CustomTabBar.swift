//
//  CustomTabBar.swift
//  SinaWeibo
//
//  Created by baby on 15/8/9.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        ///设置item的选中颜色
        self.selectedImageTintColor = UIColor(red: 235/255, green: 107/255, blue: 38/255, alpha: 1)
        /// 设置Item的位置
        var i = 0
        let itemWith = kScreenWith/CGFloat(self.items!.count + 1)
        for tabbarButton in self.subviews {
            if tabbarButton.isKindOfClass(NSClassFromString("UITabBarButton")!){
                if i == 2 {
                    i = 3
                }
                tabbarButton.frame = CGRectMake(itemWith * CGFloat(i), 1, itemWith, self.bounds.height)
                i++
            }
        }
        createAddButton()
    }
    
    /**
    创建Tarbar中间的加号按钮
    */
    func createAddButton(){
        let addButton = UIButton(type: UIButtonType.Custom)
        addButton.setImage( UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        addButton.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        addButton.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        addButton.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        addButton.sizeToFit()
        addButton.center = CGPointMake(self.bounds.width / 2, self.bounds.height / 2)
        addButton.addTarget(self, action: "publishWeibo", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(addButton)
    }
    
    /**
    发布微博
    */
    func publishWeibo(){
        print("发布微博")
        
    }

        
}
