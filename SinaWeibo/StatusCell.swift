//
//  StatusCell.swift
//  SinaWeibo
//
//  Created by baby on 15/9/2.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

protocol PhotoItemDelegate{
    func photoDidClicked(photos:[AnyObject],indexPath:NSIndexPath)
}

class StatusCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource{
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
    
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var delegate:PhotoItemDelegate!
    @IBOutlet var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionTrailing: NSLayoutConstraint!
    let itemWH = (kScreenWith - 30) / 3
    
    var status:Status?{
        didSet{
            //设置名称
            self.name.text = status!.user?.name
            //用SDwebimage加载图片，设置头像
            self.avatar.sd_setImageWithURL(status!.user?.profile_image_url, placeholderImage: UIImage(named: "timeline_image_placeholder"))
            
            //设置微博图片
            let urls = status!.pic_urls
            //设置图片布局
            let photoNum = urls?.count ?? 0
            layoutPhotos(photoNum, collectionHeight: collectionHeight, collectionTrailing: collectionTrailing, flowLayout: flowLayout)
            self.photoCollection.reloadData()
            
            
            //设置正文内容
            self.statusText.text = status!.text
            if status!.retweeted_status != nil {
                if let retweetName = status!.retweeted_status?.user?.name {
                    self.retweetText.text = "@" + retweetName + "：" + (status!.retweeted_status!.text)!
                }
            }else{
                self.retweetText.text = nil
            }
            
            if let created_at = status!.created_at {
                let createdDate = StringConvertTool.dateStringConverter(created_at)
                self.createdDate.text = createdDate
            }
            
            //设置来源
            if let source = status!.source {
                let sourceString = StringConvertTool.sourceStringConverter(source)
                self.source.text = sourceString
            }
            //设置转发数
            if let reposts_count = status!.reposts_count where reposts_count != "0"{
                self.retweetButton.setTitle(reposts_count, forState: UIControlState.Normal)
            }else{
                self.retweetButton.setTitle("转发", forState: .Normal)
            }
            //设置评论数
            if let comments_count = status!.comments_count where comments_count != "0"{
                self.commentButton.setTitle(comments_count, forState: UIControlState.Normal)
            }else{
                self.commentButton.setTitle("评论", forState: .Normal)
            }
            //设置点赞数
            if let attitudes_count = status!.attitudes_count where attitudes_count != "0"{
                self.likeButton.setTitle(attitudes_count, forState: UIControlState.Normal)
            }else{
                self.likeButton.setTitle("赞", forState: .Normal)
            }
            
            //设置会员标识
            if status!.user!.isVip() {
                self.vipIcon.image = UIImage(named: "common_icon_membership_level\(status!.user!.mbrank!)")
                self.name.textColor = UIColor.orangeColor()
            }else{
                self.vipIcon.image = nil
                self.name.textColor = UIColor.blackColor()
            }
            
        }
    }
    
    //设置布局
    private func layoutPhotos(numberOfPhotos:Int,collectionHeight:NSLayoutConstraint,collectionTrailing:NSLayoutConstraint,flowLayout:UICollectionViewFlowLayout){
        switch numberOfPhotos {
        case 1:
            collectionHeight.constant = itemWH * 1.3
            collectionTrailing.constant = 10
            flowLayout.itemSize = CGSizeMake(itemWH * 1.3, itemWH * 1.3)
        case 2...3:
            collectionHeight.constant = itemWH + 5
            collectionTrailing.constant = 10
            flowLayout.itemSize = CGSizeMake(itemWH, itemWH)
        case 4:
            collectionHeight.constant = (itemWH + 5) * CGFloat(2)
            collectionTrailing.constant = itemWH + 15
            self.flowLayout.itemSize = CGSizeMake(itemWH, itemWH)
        case 5...6:
            collectionHeight.constant = (itemWH + 5) * CGFloat(2)
            collectionTrailing.constant = 10
            self.flowLayout.itemSize = CGSizeMake(itemWH, itemWH)
        case 7...9:
            collectionHeight.constant = (itemWH + 5) * CGFloat(3)
            collectionTrailing.constant = 10
            flowLayout.itemSize = CGSizeMake(itemWH, itemWH)
        default:
            collectionHeight.constant = 0
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoCollection.delegate = self
        photoCollection.dataSource = self
        
        //工具栏分割限布局
        lineLeading.constant = kScreenWith / 3
        lineLeading1.constant = kScreenWith / 3
    }
    
    //MARK: collectionView的代理方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.pic_urls?.count ?? 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoItem", forIndexPath: indexPath)
        let statusImageView = cell.viewWithTag(88) as! UIImageView
        let photo = status?.pic_urls![indexPath.item] as! Photo
        statusImageView.sd_setImageWithURL(photo.thumbnail_pic, placeholderImage: UIImage(named: "timeline_image_placeholder"))
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate.photoDidClicked(status!.pic_urls!,indexPath: indexPath)
    }
}
