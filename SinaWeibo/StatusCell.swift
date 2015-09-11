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
        //工具栏分割限布局
        lineLeading.constant = kScreenWith / 3
        lineLeading1.constant = kScreenWith / 3
        
        
        //给所有图片添加手势
        for imageView in statusImage {
            let tap = UITapGestureRecognizer(target:self, action: "tapPhoto:")
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
        }
        
        //设置图标的高度
        for (index,imageView) in statusImage.enumerate() {
            if index % 3 == 0 {
                imgHeight = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: (kScreenWith - 30) / 3)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imgHeight.active = true
                imageView.fd_autoCollapse = true
                imageView.fd_collapsibleConstraints.append(imgHeight)
            }
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func tapPhoto(tap:UITapGestureRecognizer){
        let view = tap.view as! UIImageView//点击取得View
        let tag = view.tag
        var urls:[NSURL] = []
        for index in 1...9 {
            let imgV = self.viewWithTag(index) as! UIImageView //用tag取得点击后这个cell的所有图片
            let url = imgV.sd_imageURL()
            if url != nil {
                let urlStr = String(url).stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")//替换小图为中图
                let URL = NSURL(string: urlStr)
                urls.append(URL!)
            }
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let photoBrowser = storyBoard.instantiateViewControllerWithIdentifier("photo") as! PhotoCollectionViewController
        
        photoBrowser.imgUrls = urls
        photoBrowser.currentImage = tag
        
        //用响应链取得controller
        var anyOB = self.nextResponder()
        while !(anyOB!.isKindOfClass(HomeTableViewController))  {
            anyOB = anyOB?.nextResponder()
        }
        let vc = anyOB as! HomeTableViewController
        
        vc.presentViewController(photoBrowser, animated: false, completion: nil)
    }
    
    


}
