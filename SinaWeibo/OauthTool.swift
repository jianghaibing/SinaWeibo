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

        let fetchRequst = NSFetchRequest(entityName: "AccountDB")
        let results = try! managedObjectContext.executeFetchRequest(fetchRequst)
        if results.count > 0 {
            let account = results[0] as! AccountDB
            expireDate = NSDate(timeInterval:account.expires_in!.doubleValue, sinceDate: account.date!)
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
        let fetchRequst = NSFetchRequest(entityName: "AccountDB")
        let countFetched = managedObjectContext.countForFetchRequest(fetchRequst, error: nil)
        if countFetched == 0 {
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
            
//            let entity = NSEntityDescription.entityForName("AccountDB", inManagedObjectContext: managedObjectContext)
//            let account = AccountDB(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            let account = NSEntityDescription.insertNewObjectForEntityForName("AccountDB", inManagedObjectContext: managedObjectContext) as! AccountDB
            // 添加当前时间到字典，即在数据库写入创建时间
            let responseObject = responseObject as! NSDictionary
            account.access_token = responseObject["access_token"] as? String
            account.uid = responseObject["uid"] as? String
            account.expires_in = responseObject["expires_in"] as? NSNumber
            account.date = NSDate()
            do {
                try managedObjectContext.save()
            }catch{
                fatalError()
            }
            
            /**
            *  成功登录时获取万数据跳转界面
            */
            sucess()
            
            }) { (error) -> Void in
                failure(error)
        }
        
    }


    
    
}
