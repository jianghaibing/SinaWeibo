//
//  Status.swift
//  SinaWeibo
//
//  Created by baby on 15/8/23.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class Status: NSObject {
    
    /// 微博创建时间,换换时间格式，新浪微博日期格式：EEE MMM dd HH:mm:ss zzz yyyy
    var created_at:String?
    /// 字符串型的微博ID
    var idstr:String?
    /// 微博信息内容
    var text:String?
    /// 微博来源
    var source:String?
    /// 微博作者的用户信息字段 详细
    var user:User?
    /// 转发的原微博信息字段，当该微博为转发微博时返回 详细
    var retweeted_status:Status?
    /// 转发数
    var reposts_count:Int?
    /// 评论数
    var comments_count:Int?
    /// 表态数
    var attitudes_count:Int?
    /// 微博配图url数组
    var pic_urls:[Photo]?

}
