//
//  OauthTool.swift
//  SinaWeibo
//
//  Created by baby on 15/8/23.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class OauthTool: NSObject {
    
    
    /// 验证token是否过期，是已过期，否未过期
    class func tokenIsExpire() -> Bool{
        
        var expireDate:NSDate?
        if Account.fetchData().expires_in != nil {
            /// 获取过期时间
            expireDate = NSDate(timeInterval: Account.fetchData().expires_in! , sinceDate: Account.fetchData().date!)
        }else{
            expireDate = NSDate(timeIntervalSinceNow: 100)
        }

        if NSDate().compare(expireDate!) != NSComparisonResult.OrderedAscending {
            return true
        }else{
            return false
        }
    }
    
    /// 验证token是否存在，是表示不存在，否表示存在
    class func tokenIsNotExist() -> Bool {
        if Account.fetchData().access_token == nil {
            return true
        }else{
            return false
        }
    }
    

}
