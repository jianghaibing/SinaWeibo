//
//  StatusCell.swift
//  SinaWeibo
//
//  Created by baby on 15/9/2.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

protocol PhotoItemDelegate{
    func photoDidClicked(photos:NSMutableArray,indexPath:NSIndexPath)
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
    var photos:NSMutableArray?
    
    
    var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionTrailing: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoCollection.delegate = self
        photoCollection.dataSource = self
        
        collectionHeight = photoCollection.heightAnchor.constraintEqualToConstant(0)
        collectionHeight.active = true
        photoCollection.translatesAutoresizingMaskIntoConstraints = false
        
        //工具栏分割限布局
        lineLeading.constant = kScreenWith / 3
        lineLeading1.constant = kScreenWith / 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoItem", forIndexPath: indexPath)
        let statusImageView = cell.viewWithTag(88) as! UIImageView
        if photos != nil {
            let photo = photos![indexPath.item] as! Photo
            statusImageView.sd_setImageWithURL(photo.thumbnail_pic, placeholderImage: UIImage(named: "timeline_image_placeholder"))
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate.photoDidClicked(photos!,indexPath: indexPath)
    }
    


}
