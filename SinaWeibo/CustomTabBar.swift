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
        self.selectedImageTintColor = UIColor.colorWithRGB(235, green: 107, blue: 38, alpha: 1)
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
                /**
                *  自定义bagdeView
                */
                for badgeView in tabbarButton.subviews{
                    if badgeView.isKindOfClass(NSClassFromString("_UIBadgeView")!){
                        let lable = badgeView.subviews[1] as! UILabel
                        lable.font = UIFont.systemFontOfSize(11)
                        let backgoundView = badgeView.subviews[0] as UIView
                        backgoundView.tintColor = UIColor.colorWithRGB(208, green: 87, blue: 55, alpha: 1)
                        /**
                        *  当数字大于99时显示99+
                        */
                        if (lable.text! as NSString).length > 2{
                            lable.text = "99+"
                        }
                        /**
                        *  当设置badgeValue为点时，显示小红点
                        */
                        if lable.text == "点" {
                            backgoundView.hidden = true
                            let background = UIImageView(image: UIImage(named: "new_dot"))
                            background.frame.origin.x -= 4
                            background.frame.origin.y += 2
                            badgeView.addSubview(background)
                            
                        }else{
                            backgoundView.hidden = false
                        }
                        
                    }
                }
            }
        }
        
    }
    
    /**
    创建Tarbar中间的加号按钮
    */
    func createAddButton() -> UIButton {
        let addButton = UIButton(type: UIButtonType.Custom)
        addButton.setImage( UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        addButton.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        addButton.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        addButton.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        addButton.sizeToFit()
        addButton.center = CGPointMake(self.bounds.width / 2, self.bounds.height / 2)
        self.addSubview(addButton)
        return addButton
    }
    
    
}
