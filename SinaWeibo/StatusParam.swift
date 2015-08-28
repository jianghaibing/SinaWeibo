//
//  StatusParam.swift
//  SinaWeibo
//
//  Created by baby on 15/8/28.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//  微博请求的参数模型



import UIKit

class StatusParam: NSObject {
    
    var access_token:String?
    var since_id:String?
    var max_id:String?
    
    class var shareInstance:StatusParam {
        struct Intance {
            static let statusParam = StatusParam()
        }
        return Intance.statusParam
    }

}
