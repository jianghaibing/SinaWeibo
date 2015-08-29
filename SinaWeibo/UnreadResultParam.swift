//
//  UnreadResultParam.swift
//  SinaWeibo
//
//  Created by baby on 15/8/29.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class UnreadResultParam: NSObject {
 /// 新微博未读数
    var status:Int?
 /// 新粉丝数
    var follower:Int?
 /// 新评论数
    var cmt:Int?
 /// 新私信数
    var dm:Int?
 /// 新提及我的微博数
    var mention_status:Int?
 /// 新提及我的评论数
    var mention_cmt:Int?
    
    func getUnreadMessageCount() -> Int {
        return cmt! + dm! + mention_cmt! + mention_status!
    }
    
    func getTotalUnreadCount() -> Int{
        return getUnreadMessageCount() + status! + follower!
    }
    

}
