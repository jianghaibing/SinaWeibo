//
//  HTTPRequestTool.swift
//  SinaWeibo
//
//  Created by baby on 15/8/27.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

 /*
  * 封装的网络类
  */

import UIKit

class HTTPRequestTool: NSObject {

    class func POST(URLString: String, parameters: AnyObject?, success: (AnyObject) -> Void, failure: (NSError) -> Void){
        
        let manager = AFHTTPRequestOperationManager()
        manager.POST(URLString, parameters: parameters, success: { (_, response) -> Void in
            success(response)
            }) { (_, error) -> Void in
                print(error)
        }
        
    }
    
    class func GET(URLString: String, parameters: AnyObject?, success: (AnyObject) -> Void, failure: (NSError) -> Void){
        let manager = AFHTTPRequestOperationManager()
        manager.GET(URLString, parameters: parameters, success: { (_, response) -> Void in
            success(response)
            }) { (_, error) -> Void in
                print(error)
        }

    }
    
    
    
}
