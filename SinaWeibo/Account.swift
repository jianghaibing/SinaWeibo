//
//  Account.swift
//  SinaWeibo
//
//  Created by baby on 15/8/23.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class Account: NSObject {
    
    var token:String?
    var expiresIn:NSTimeInterval?
    var uid:String?
    var date:NSDate?
    
    /// 单例创建实例
    class var shareInstance:Account {
        //用结构体创建静态常量实例
        struct Static {
            static let instance = Account()
        }
        return Static.instance
    }

    override init(){
        /// 从数据库取用户数据
        let db = NyaruDB.instance()
        let collection = db.collection("User")
        let documents = collection.all().fetch()
        if documents.count > 0 {
            self.token = documents[0]["access_token"] as? String
            self.expiresIn = documents[0]["expires_in"] as? NSTimeInterval
            self.uid = documents[0]["uid"] as? String
            self.date = documents[0]["date"] as? NSDate
        }else{
            self.token = nil
            self.expiresIn = nil
            self.uid = nil
            self.date = nil
        }
    }

}
