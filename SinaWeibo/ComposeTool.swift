//
//  ComposeTool.swift
//  SinaWeibo
//
//  Created by baby on 15/9/13.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//  发布微博的接口

import UIKit
import RealmSwift

class ComposeTool: NSObject {

    class func composeWeiboWithText(status:String,sucess:()->Void,failure:(NSError) -> Void){
        
        let params = ComposeParam()
        params.status = status
        let fetchRequst = NSFetchRequest(entityName: "AccountDB")
        let results = try! managedObjectContext.executeFetchRequest(fetchRequst)
        if results.count > 0 {
            let account = results[0] as! AccountDB
            params.access_token = account.access_token
        }
        HTTPRequestTool.POST("https://api.weibo.com/2/statuses/update.json", parameters: params.keyValues(), success: { (_) -> Void in
            sucess()
            }) { (error) -> Void in
            failure(error)
        }
    }
    
 
    class func composeWeiboWithPhoto(status:String,image:UIImage, sucess:()->Void,failure:(NSError) -> Void){
        
        let params = ComposeParam()
        let temStatus = status.isEmpty ? "分享图片":status
        params.status = temStatus
        let fetchRequst = NSFetchRequest(entityName: "AccountDB")
        let results = try! managedObjectContext.executeFetchRequest(fetchRequst)
        if results.count > 0 {
            let account = results[0] as! AccountDB
            params.access_token = account.access_token
        }
        
        let uploadParams = UploadParam()
        uploadParams.data = UIImagePNGRepresentation(image)
        uploadParams.name = "pic"
        uploadParams.fileName = "myphoto.png"
        uploadParams.mimeType = "image/png"
        
        HTTPRequestTool.Upload("https://upload.api.weibo.com/2/statuses/upload.json", parameters: params.keyValues(), uploadParam: uploadParams, success: { (_) -> Void in
            sucess()
            }) { (error) -> Void in
                failure(error)
        }
        
    }

    
}
