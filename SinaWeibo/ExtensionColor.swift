//
//  ExtensionColor.swift
//  SinaWeibo
//
//  Created by baby on 15/8/15.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

extension UIColor {

    /**
    一个不用除以255的RGB方法
    */
    static func colorWithRGB(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    
}
