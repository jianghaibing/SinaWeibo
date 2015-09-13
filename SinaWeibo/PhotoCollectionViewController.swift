//
//  PhotoCollectionViewController.swift
//  SinaWeibo
//
//  Created by baby on 15/9/9.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit


class PhotoCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var currentImage:Int!
    var imgUrls:[NSURL] = []
    var lable:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        flowLayout.itemSize = UIScreen.mainScreen().bounds.size
        flowLayout.minimumLineSpacing = 0
        
        lable = UILabel(frame: CGRectMake((kScreenWith - 60)/2, 20, 60, 30))
        lable.textColor = UIColor.whiteColor()
        lable.text = "\(currentImage)/\(imgUrls.count)"
        lable.backgroundColor = UIColor.colorWithRGB(240, green: 240, blue: 240, alpha: 0.2)
        lable.textAlignment = .Center
        lable.layer.cornerRadius = 15.0
        lable.layer.masksToBounds = true

        view.addSubview(lable)
        
        let offset = CGPointMake(kScreenWith * CGFloat(currentImage - 1), 0)
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        let imgView = cell.viewWithTag(99) as! UIImageView
        
        imgView.sd_setImageWithURL(imgUrls[indexPath.row], placeholderImage: nil, options: SDWebImageOptions(rawValue: 0), progress: { (_, _) -> Void in
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            }) { (_, _, _, _) -> Void in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
        
        return cell
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let currentPage:Int = Int(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) + 1
        lable.text = "\(currentPage)/\(imgUrls.count)"
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        self.dismissViewControllerAnimated(false, completion: nil)
        imgUrls = []
        return true
    }


    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
