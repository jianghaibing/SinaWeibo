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

class StatusTool: NSObject {
    
    /// 请求新微博数据
    class func newStatuses(sinceID:String?, sucess:(NSMutableArray) -> Void, failure:(NSError) ->Void ){
        
        let params = StatusParam.shareInstance
        
        params.access_token = Account.shareInstance.access_token!

        if ((sinceID) != nil){
            params.since_id = sinceID
        }
        
        HTTPRequestTool.GET("https://api.weibo.com/2/statuses/friends_timeline.json", parameters: params.keyValues(), success: { (result) -> Void in
            
            let dictArry = result["statuses"]//取到最新微博数组
            let newStatus = Status.objectArrayWithKeyValuesArray(dictArry)//数组字典转模型
            
            sucess(newStatus)
        
            }) { (error) -> Void in
                failure(error)
        }
        
    }
    
    
    /// 请求更多微博数据
    class func moreStatuses(maxID:String?, sucess:(NSMutableArray) -> Void, failure:(NSError) ->Void ){
        
        let params = StatusParam.shareInstance
        
        params.access_token = Account.shareInstance.access_token!

        if ((maxID) != nil){
            params.max_id = maxID
        }
        
        HTTPRequestTool.GET("https://api.weibo.com/2/statuses/friends_timeline.json", parameters: params.keyValues(), success: { (result) -> Void in
            
            let dictArry = result["statuses"]//取到最新微博数组
            let moreStatus = Status.objectArrayWithKeyValuesArray(dictArry)//数组字典转模型
            
            sucess(moreStatus)
            
            }) { (error) -> Void in
                failure(error)
        }
        
    }
    
    

}