//
//  ComposePhotosView.swift
//  SinaWeibo
//
//  Created by baby on 15/9/13.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//  发送微博添加图片视图

import UIKit

class ComposePhotosView: UIView {

    var image:UIImage! {
        didSet{
            let imageView = UIImageView(image: image)
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            self.addSubview(imageView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cols = 3
        let margin:CGFloat = 10
        let wh = (self.bounds.size.width - CGFloat(cols - 1) * margin) / CGFloat(cols)
        
        var x:CGFloat = 0
        var y:CGFloat = 0
        var col = 0
        var row = 0
        
        for (i,imageView) in self.subviews.enumerate() {
            col = i % cols
            row = i / cols
            x = CGFloat(col) * (margin + wh)
            y = CGFloat(row) * (margin + wh)
            imageView.frame = CGRectMake(x, y, wh, wh)
        }
        
    }

}
