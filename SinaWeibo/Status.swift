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
    var created_at:String?{
        didSet{
            let df = NSDateFormatter()
            df.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
            df.locale = NSLocale(localeIdentifier: "en_US")
            let date = df.dateFromString(created_at!)
            let now = NSDate()
            
            let createdYear = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: date!)
            let thisYear = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: now)
            
            let deltaTimeInterval = Int(now.timeIntervalSinceDate(date!))
           
            if createdYear != thisYear {
                df.dateFormat = "yyyy-MM-dd HH:mm"
            }else if deltaTimeInterval >= 3600*24*2 {
                df.dateFormat = "MM-dd HH:mm"
            }else if deltaTimeInterval >= 3600*24 && deltaTimeInterval < 3600*24*2 {
                df.dateFormat = "昨天 HH:mm"
            }else if deltaTimeInterval >= 3600 && deltaTimeInterval < 3600*24 {
                df.dateFormat = "\(deltaTimeInterval/3600)小时之前"
            }else if deltaTimeInterval >= 60 && deltaTimeInterval < 3600 {
                df.dateFormat = "\(deltaTimeInterval/60)分钟之前"
            }else if deltaTimeInterval < 60 {
                df.dateFormat = "刚刚"
            }
            self.created_at = df.stringFromDate(date!)
            
            
        }
    }
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
