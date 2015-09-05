//
//  UnreadTool.swift
//  SinaWeibo
//
//  Created by baby on 15/8/29.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//  处理未读数据的工具类

import UIKit

class UserTool: NSObject {
    
    class func getUnreadCount(sucess:(UnreadResultParam) -> Void, failure:(NSError) -> Void){
        
        let params = UnreadParam()
        
        let fetchRequst = NSFetchRequest(entityName: "AccountDB")
        
        let results = try! managedObjectContext.executeFetchRequest(fetchRequst)
        if results.count > 0 {
            let account = results[0] as! AccountDB
            params.access_token = account.access_token
            params.uid = account.uid
        }
        
        HTTPRequestTool.GET("https://rm.api.weibo.com/2/remind/unread_count.json", parameters: params.keyValues(), success: { (result) -> Void in
        
            let unreadResult = UnreadResultParam()
            unreadResult.status = result["status"] as? Int
            unreadResult.follower = result["follower"] as? Int
            unreadResult.cmt = result["cmt"] as? Int
            unreadResult.dm = result["dm"] as? Int
            unreadResult.mention_status = result["mention_status"] as? Int
            unreadResult.mention_cmt = result["mention_cmt"] as? Int
            
            sucess(unreadResult)
            }) { (error) -> Void in
                failure(error)
        }
    }
    
    
    class func getUserName(sucess:(User) -> Void, failure:(NSError) -> Void){
        
        let params = UnreadParam()
        
        let fetchRequst = NSFetchRequest(entityName: "AccountDB")
        
        let results = try! managedObjectContext.executeFetchRequest(fetchRequst)
        if results.count > 0 {
            let account = results[0] as! AccountDB
            params.access_token = account.access_token
            params.uid = account.uid
        }
        
        HTTPRequestTool.GET("https://api.weibo.com/2/users/show.json", parameters: params.keyValues(), success: { (result) -> Void in
            
            let user = User()
            user.name = result["name"] as? String
            
            NSUserDefaults.standardUserDefaults().setObject(user.name, forKey: "name")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            sucess(user)
            }) { (error) -> Void in
                failure(error)
        }
    }

    
    
}
