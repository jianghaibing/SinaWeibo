//
//  CustomOverlay.swift
//  SinaWeibo
//
//  Created by baby on 15/8/16.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

protocol OverlayDelegate {
    
    /**
    蒙蔽被点击时调用代理方法
    */
    func didClickOverlay(overlay:CustomOverlay)
}

class CustomOverlay: UIView {

    var delegate:OverlayDelegate?

    /// 显示蒙版
    class func show() -> CustomOverlay {
        let overlay = CustomOverlay(frame: UIScreen.mainScreen().bounds)
        overlay.backgroundColor = UIColor.clearColor()
        kKeyWindow?.addSubview(overlay)
        return overlay
    }
    

    /**
    点击蒙版时，移除自身，并触发代理
    */
    internal override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.removeFromSuperview()
        delegate?.didClickOverlay(self)
    }
    
    
}
