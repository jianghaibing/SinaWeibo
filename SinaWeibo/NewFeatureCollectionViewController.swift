//
//  NewFeatureCollectionViewController.swift
//  SinaWeibo
//
//  Created by baby on 15/8/17.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit



class NewFeatureCollectionViewController: UICollectionViewController {

    var pageControl:UIPageControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        /// 设置新的布局样式
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = UIScreen.mainScreen().bounds.size
        layout.minimumLineSpacing = 0
        
        addPageControl()
    }
    
    /**
    添加pagecontrol在当前视图上
    */
    func addPageControl(){
        pageControl = UIPageControl(frame: CGRectMake(kScreenWith/2 - 50, kScreenHeight - 20 - 39, 100, 39))
        pageControl!.numberOfPages = 4
        pageControl!.pageIndicatorTintColor = UIColor.blackColor()
        pageControl!.currentPageIndicatorTintColor = UIColor.redColor()
        self.view.addSubview(pageControl!)

    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        /// 计算当在第几页
        let page:Int = Int(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5)
        pageControl!.currentPage = page
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        /// 用tag拿到imageView，设置图片
        let imageView = cell.viewWithTag(100) as! UIImageView
        imageView.image = UIImage(named: "new_feature_\(indexPath.row + 1)")
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

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
