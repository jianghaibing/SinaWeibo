//
//  StatusCell.swift
//  SinaWeibo
//
//  Created by baby on 15/9/2.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell{
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var vipIcon: UIImageView!
    
    @IBOutlet weak var retweetText: UILabel!
  
    @IBOutlet weak var lineLeading: NSLayoutConstraint!
    @IBOutlet weak var lineLeading1: NSLayoutConstraint!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    @IBOutlet var statusImage: [UIImageView]!
    @IBOutlet weak var imgHeight1: NSLayoutConstraint!
    @IBOutlet weak var imgWidth1: NSLayoutConstraint!
    @IBOutlet weak var imgHeight4: NSLayoutConstraint!
    @IBOutlet weak var imgWidth4: NSLayoutConstraint!
    @IBOutlet weak var imgHeight7: NSLayoutConstraint!
    @IBOutlet weak var imgWidth7: NSLayoutConstraint!
    var imgWH:CGFloat!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineLeading.constant = kScreenWith / 3
        lineLeading1.constant = kScreenWith / 3
        
        imgWH = (kScreenWith - 30) / 3

//        imgHeight1.constant = imgWH
        imgWidth1.constant = imgWH
        
//        imgHeight4.constant = imgWH
        imgWidth4.constant = imgWH
        
//        imgHeight7.constant = imgWH
        imgWidth7.constant = imgWH
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
  

}
