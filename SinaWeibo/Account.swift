//
//  Account.swift
//  SinaWeibo
//
//  Created by baby on 15/8/22.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import Foundation

//let _sigletonInstance = Account()

class Account:NSObject {
    
    
//    class var shareInstance:Account {
//        return _sigletonInstance
//    }
    /**
    *  "access_token" : "2.00uUHLEDW7HDdC6738759c6cBqH6iD",
    "remind_in" : "157679999",
    "uid" : "2810154272",
    "expires_in" : 157679999
    */
    
    var accessToken:String?
    var expiresIn:String?
    var uid:String?
    
    init(dict:Dictionary<String,AnyObject>){
        self.accessToken = dict["access_token"] as? String
        self.expiresIn = dict["expires_in"] as? String
        self.uid = dict["uid"] as? String
    }
    
    
}