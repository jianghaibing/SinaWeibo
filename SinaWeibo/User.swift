//
//  User.swift
//  SinaWeibo
//
//  Created by baby on 15/8/23.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class User: NSObject {
    
    /**
    *  微博昵称
    */
    var name:String?
    
    /**
    *  微博头像
    */
    var profile_image_url:NSURL?
    
 /// 会员类型 >2表示是会员
    var mbtype:String?
    
 /// 会员等级
    var mbrank:String?
  
    /// 是否是vip
    func isVip() -> Bool {
        if Int(mbtype!) > 2 {
                return true
            }else{
                return false
            }
    }
}
