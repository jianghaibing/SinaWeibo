//
//  RetweetStatusLocal.swift
//  SinaWeibo
//
//  Created by baby on 15/11/26.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import Foundation
import RealmSwift

class RetweetStatusLocal: Object {
    
    /// 微博创建时间,换换时间格式，新浪微博日期格式：EEE MMM dd HH:mm:ss zzz yyyy
    dynamic var created_at:String = ""
    /// 字符串型的微博ID
    dynamic var idstr:String = ""
    /// 微博信息内容
    dynamic var text:String? = nil
    /// 微博来源
    dynamic var source:String? = nil
    /// 微博作者的用户信息字段 详细
    dynamic var user:RetweetUserLocal?
    /// 转发数
    dynamic var reposts_count:String? = nil
    /// 评论数
    dynamic var comments_count:String? = nil
    /// 表态数
    dynamic var attitudes_count:String? = nil
    /// 微博配图url数组
    let  pic_urls = List<PhotoLocal>()}
