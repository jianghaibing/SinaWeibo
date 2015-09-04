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
    var imgHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineLeading.constant = kScreenWith / 3
        lineLeading1.constant = kScreenWith / 3
        
        for imageView in statusImage {
            imgHeight = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: (kScreenWith - 30) / 3)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imgHeight.active = true
            imageView.fd_autoCollapse = true
            imageView.fd_collapsibleConstraints.append(imgHeight)
        }
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
  

}
