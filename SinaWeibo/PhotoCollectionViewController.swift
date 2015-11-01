//
//  PhotoCollectionViewController.swift
//  SinaWeibo
//
//  Created by baby on 15/9/9.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit


class PhotoCollectionViewController: UICollectionViewController,PhotoCellDelegate {

    let popTranstion = PopTransitionAnimator()
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    //当前照片索引
    var currentImageIndex:Int!
    //照片url数组
    var imgUrls:[NSURL] = []
    private var lable:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        flowLayout.itemSize = UIScreen.mainScreen().bounds.size
        flowLayout.minimumLineSpacing = 0
        
        lable = UILabel(frame: CGRectMake((kScreenWith - 60)/2, 20, 60, 30))
        lable.textColor = UIColor.whiteColor()
        lable.text = "\(currentImageIndex)/\(imgUrls.count)"
        lable.backgroundColor = UIColor.colorWithRGB(240, green: 240, blue: 240, alpha: 0.2)
        lable.textAlignment = .Center
        lable.layer.cornerRadius = 15.0
        lable.layer.masksToBounds = true

        view.addSubview(lable)
        
        let deletePhotoBtn = UIButton(frame: CGRectMake(kScreenWith - 80, kScreenHeight - 60, 50, 35))
        deletePhotoBtn.setTitle("删除", forState: UIControlState.Normal)
        deletePhotoBtn.backgroundColor = UIColor.colorWithRGB(240, green: 240, blue: 240, alpha: 0.5)
        deletePhotoBtn.addTarget(self, action: "deletePhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(deletePhotoBtn)
        
        let offset = CGPointMake(kScreenWith * CGFloat(currentImageIndex - 1), 0)
        collectionView!.setContentOffset(offset, animated: false)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imgUrls.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PhotoCell
        cell.setupImageView(imgUrls[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        currentImageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) + 1
        lable.text = "\(currentImageIndex)/\(imgUrls.count)"
    }
    
    
    func deletePhoto(sender: UIButton) {
        let indexPath = NSIndexPath(forRow:currentImageIndex-1, inSection: 0)
        if imgUrls.count == 1 {
            self.dismissViewControllerAnimated(true, completion: nil)
            imgUrls.removeAtIndex(currentImageIndex-1)
            collectionView?.deleteItemsAtIndexPaths([indexPath])
            currentImageIndex = currentImageIndex - 1
            lable.text = "\(currentImageIndex)/\(imgUrls.count)"
        }else  if currentImageIndex == imgUrls.count {
            imgUrls.removeAtIndex(currentImageIndex-1)
            collectionView?.deleteItemsAtIndexPaths([indexPath])
            currentImageIndex = currentImageIndex - 1
            lable.text = "\(currentImageIndex)/\(imgUrls.count)"
        }else{
            imgUrls.removeAtIndex(currentImageIndex-1)
            collectionView?.deleteItemsAtIndexPaths([indexPath])
            lable.text = "\(currentImageIndex)/\(imgUrls.count)"
        }
    }
    
    
    //MARK: 点击照片的代理方法
    func colsePhoto() {
        dismissViewControllerAnimated(true, completion: nil)
    }


}
