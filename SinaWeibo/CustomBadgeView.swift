//
//  CustomBadgeView.swift
//  SinaWeibo
//
//  Created by baby on 15/8/13.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class CustomBadgeView: UIButton {

    var badgeValue:String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = false
        self.setBackgroundImage(UIImage(named: "main_badge"), forState: UIControlState.Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(11)
        self.sizeToFit()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBadgeVlue(badgeValue:String){
        self.badgeValue = badgeValue
        /**
        *  如果badgeValue为空或为0时隐藏
        */
        if badgeValue.isEmpty || badgeValue == "0"{
            self.hidden = true
        }else{
            self.hidden = false
        }
        
        
        /// 计算文字的大小，使用NSString的方法来计算
        let badgeValueSize = (badgeValue as NSString).sizeWithAttributes([NSFontAttributeName : UIFont.systemFontOfSize(11)])
        /**
        *  文字的长度大于BadgeView的长度时设置为new_dot图片
        */
        if badgeValueSize.width > self.bounds.width {
            self.setImage(UIImage(named: "new_dot"), forState: UIControlState.Normal)
            self.setTitle(nil, forState: UIControlState.Normal)
            self.setBackgroundImage(nil, forState: UIControlState.Normal)
        }else{
            self.setImage(UIImage(named: "main_badge"), forState: UIControlState.Normal)
            self.setTitle(badgeValue, forState: UIControlState.Normal)
            self.setBackgroundImage(nil, forState: UIControlState.Normal)

        }
        
        
    }
    
    

    

}
