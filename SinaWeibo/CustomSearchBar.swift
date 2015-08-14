//
//  CustomSearchBar.swift
//  SinaWeibo
//
//  Created by baby on 15/8/12.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class CustomSearchBar: UITextField {

    /**
    自定义一个textfield，设置背景图片、left图片
   
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.background = UIImage(named: "searchbar_textfield_background")
        self.leftView = UIImageView(image: UIImage(named: "searchbar_textfield_search_icon"))
        self.font = UIFont.systemFontOfSize(13)
        self.returnKeyType = UIReturnKeyType.Search
        self.leftViewMode = UITextFieldViewMode.Always
        self.leftView?.bounds.size.width += 10
        self.leftView?.contentMode = UIViewContentMode.Center
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
  

    
}
