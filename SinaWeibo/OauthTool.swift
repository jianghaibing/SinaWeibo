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
            // 获取过期时间
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
    
    /// 通过code换取token登录
    class func accessWithCode(code:String, sucess:() ->Void, failure:(NSError) -> Void){
        // 参数
        let params = AccountParam()
        params.client_id = kAppKey
        params.client_secret = kAppSecret
        params.grant_type = "authorization_code"
        params.code = code
        params.redirect_uri = kRedirectURL
        
        HTTPRequestTool.POST("https://api.weibo.com/oauth2/access_token", parameters: params.keyValues(), success: { (responseObject) -> Void in
            
            // 添加当前时间到字典，即在数据库写入创建时间
            let dict = NSMutableDictionary(dictionary: responseObject as! [NSObject : AnyObject])
            dict["date"] = NSDate()
            let account = Account.shareInstance
            account.access_token = dict["access_token"] as? String
            account.uid = dict["uid"] as? String
            account.expires_in = dict["expires_in"] as? NSTimeInterval
            account.date = dict["date"] as? NSDate
            
            // 存储数据
            let db = NyaruDB.instance()
            let collection = db.collection("User")
            collection.createIndex("uid")//创建uid作为数据库索引
            let documents = collection.all().fetch()//查询所有数据
            /**
            *  当数据库已有用户数据时，清除数据
            */
            if documents.count > 0 {
                collection.removeAll()
            }
            /**
            *  添加最新数据到数据库
            */
            collection.put(dict as [NSObject : AnyObject])
            /**
            *  成功登录时获取万数据跳转界面
            */
            sucess()
            
            }) { (error) -> Void in
                failure(error)
        }
        
    }


    
    
}
