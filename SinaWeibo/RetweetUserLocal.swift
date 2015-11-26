//
//  RetweetUserLocal.swift
//  SinaWeibo
//
//  Created by baby on 15/11/26.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import Foundation
import RealmSwift

class RetweetUserLocal: Object {
    /**
     *  微博昵称
     */
    dynamic var name:String = ""
    
    /**
     *  微博头像
     */
    dynamic var profile_image_url:String? = nil
    
    /// 会员类型 >2表示是会员
    dynamic var mbtype:String = ""
    
    /// 会员等级
    dynamic var mbrank:String = ""
    
    /// 是否是vip
    dynamic var isVip:Bool = false
}
