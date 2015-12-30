//
//  StatusTool.swift
//  SinaWeibo
//
//  Created by baby on 15/8/28.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//
/*
封装微博数据类
*/


import UIKit
import RealmSwift

class StatusTool: NSObject {
    
    /// 请求新微博数据
    class func newStatuses(sinceID:String?, sucess:(NSMutableArray) -> Void, failure:(NSError) ->Void ){
        
        let params = StatusParam()
        
        let fetchRequst = NSFetchRequest(entityName: "AccountDB")
        let results = try! managedObjectContext.executeFetchRequest(fetchRequst)
        if results.count > 0 {
            let account = results[0] as! AccountDB
            params.access_token = account.access_token
        }
        
        
        if ((sinceID) != nil){
            params.since_id = sinceID
        }
        
        
        HTTPRequestTool.GET("https://api.weibo.com/2/statuses/friends_timeline.json", parameters: params.mj_keyValues(), success: { (result) -> Void in
            
            let dictArry = (result as! NSDictionary)["statuses"]//取到最新微博数组
            
            let newStatus = Status.mj_objectArrayWithKeyValuesArray(dictArry)//数组字典转模型
            
            sucess(newStatus)
            
            
            
            }) { (error) -> Void in
                failure(error)
        }
        
    }
    
    
    /// 请求更多微博数据
    class func moreStatuses(maxID:String?, sucess:(NSMutableArray) -> Void, failure:(NSError) ->Void ){
        
        let params = StatusParam()
        
        let fetchRequst = NSFetchRequest(entityName: "AccountDB")
        let results = try! managedObjectContext.executeFetchRequest(fetchRequst)
        if results.count > 0 {
            let account = results[0] as! AccountDB
            params.access_token = account.access_token
        }
        
        if ((maxID) != nil){
            params.max_id = maxID
        }
        
        HTTPRequestTool.GET("https://api.weibo.com/2/statuses/friends_timeline.json", parameters: params.mj_keyValues(), success: { (result) -> Void in
            
            let dictArry = (result as! NSDictionary)["statuses"]//取到最新微博数组
            let moreStatus = Status.mj_objectArrayWithKeyValuesArray(dictArry)//数组字典转模型
            
            sucess(moreStatus)
            
            }) { (error) -> Void in
                failure(error)
        }
        
    }
    
    
    
}
