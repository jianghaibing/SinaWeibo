//
//  CustomPopMenu.swift
//  SinaWeibo
//
//  Created by baby on 15/8/16.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class CustomPopMenu: UIImageView {
    
    
    /// 当内容视图被设置时移除原来的内容视图，添加新视图到popMenu上
    var contentView:UIView? {
        didSet {
            contentView!.removeFromSuperview()
            contentView!.backgroundColor = UIColor.clearColor()
            self.addSubview(contentView!)
        }
    }
    
    /// 显示popMenu,让popMenu显示在主wind上面
    class func showInRect(rect:CGRect) -> CustomPopMenu {
        let menu = CustomPopMenu(frame: rect)
        menu.userInteractionEnabled = true
        menu.image = UIImage(named: "popover_background")
        kKeyWindow?.addSubview(menu)
        return menu
    }
    
    /// 隐藏popMenu
    class func hide(){
        for popMenu in (kKeyWindow?.subviews)! where popMenu.isKindOfClass(self){
            popMenu.removeFromSuperview()
        }
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        //计算内容视图尺寸
        let y:CGFloat = 9.0
        let margin:CGFloat = 5.0
        let x = margin
        let w = self.bounds.size.width - 2 * margin
        let h = self.bounds.size.height - y - margin
        contentView!.frame = CGRectMake(x, y, w, h)
    }
    
}
