//
//  CustomTitleView.swift
//  SinaWeibo
//
//  Created by baby on 15/8/9.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 图片拉伸的方法，可使用Assets的slicing来拉升,已经使用了slicing
    /*
    class func imageWithStretchableName(imageName:String) -> UIImage {
        let image = UIImage(named: imageName)

        return (image?.stretchableImageWithLeftCapWidth(Int((image?.size.width)!) / 2, topCapHeight: Int((image?.size.height)!)/2))!
    }
    */
}

class CustomTitleView: UIButton {

    /**
    设置字体颜色和背景图片
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        self.setBackgroundImage(UIImage.imageWithStretchableName("navigationbar_filter_background_highlighted"), forState: UIControlState.Highlighted)
        self.setBackgroundImage(UIImage(named: "navigationbar_filter_background_highlighted"), forState: UIControlState.Highlighted)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.currentImage == nil {
            return
        }
        self.titleLabel?.frame.origin.x = 0
        /**
        设置图片的位置
        */
        self.imageView?.frame.origin.x = CGRectGetMaxX((self.titleLabel!.frame))
    }
    
    /**
    设置title时重新计算frame，使lable自适应
    */
    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: state)
        self.sizeToFit()
    }
    
    /**
    设置图片时重新计算frame，使图片自适应
    */
    override func setImage(image: UIImage?, forState state: UIControlState) {
        super.setImage(image, forState: state)
        self.sizeToFit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
