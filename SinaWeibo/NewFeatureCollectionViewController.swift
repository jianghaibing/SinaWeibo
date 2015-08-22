//
//  NewFeatureCollectionViewController.swift
//  SinaWeibo
//
//  Created by baby on 15/8/17.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit



class NewFeatureCollectionViewController: UICollectionViewController {

    private var pageControl:UIPageControl?
    private lazy var startButton = UIButton()
    private lazy var shareLabble = UILabel()
    private lazy var shareButton = UIButton()
    private let pageCount = 4
    
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
    private func addPageControl(){
        pageControl = UIPageControl(frame: CGRectMake(kScreenWith/2 - 50, kScreenHeight - 20 - 39, 100, 39))
        pageControl!.numberOfPages = pageCount
        pageControl!.pageIndicatorTintColor = UIColor.blackColor()
        pageControl!.currentPageIndicatorTintColor = UIColor.redColor()
        pageControl?.enabled = false
        self.view.addSubview(pageControl!)

    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        /// 计算当在第几页
        let page:Int = Int(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5)
        pageControl!.currentPage = page
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
        return pageCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        /// 用tag拿到imageView，设置图片
        let imageView = cell.viewWithTag(100) as! UIImageView
        if kScreenHeight == 480{
            imageView.image = UIImage(named: "new_feature_\(indexPath.row + 1)")
        }else{
            imageView.image = UIImage(named: "new_feature_\(indexPath.row + 1)-568h")
        }
        if indexPath.row == pageCount - 1 {
            startButton.setTitle("开始微博", forState: UIControlState.Normal)
            startButton.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
            startButton.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
            startButton.frame = CGRectMake(kScreenWith / 2 - 52.5, kScreenHeight - 70 - 36, 105, 36)
            startButton.addTarget(self, action: "openWeibo", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(startButton)
            
            shareButton.setImage(UIImage(named: "new_feature_share_false"), forState: UIControlState.Normal)
            shareButton.setImage(UIImage(named: "new_feature_share_true"), forState: UIControlState.Selected)
            shareButton.frame = CGRectMake(kScreenWith / 2 - 55, kScreenHeight - 120 - 36, 23, 23)
            shareButton.addTarget(self, action: "selectShareButton", forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(shareButton)
            
            shareLabble.text = "分享给大家"
            shareLabble.font = UIFont.systemFontOfSize(14)
            shareLabble.frame = CGRectMake(kScreenWith / 2 - 52.5 + 23, kScreenHeight - 160, 100, 30)
            cell.addSubview(shareLabble)
            
        }else if indexPath.row != pageCount - 2 {//不等于相邻的界面时移除界面元素
            startButton.removeFromSuperview()
            shareLabble.removeFromSuperview()
            shareButton.removeFromSuperview()
        }
        return cell
    }
    
    /**
    进入主界面
    */
    func openWeibo(){
        /// 从数据库取用户数据
        let db = NyaruDB.instance()
        let collection = db.collection("User")
        let documents = collection.all().fetch()
        var expireDate:NSDate?
        if documents.count > 0 {
            /// 获取过期时间
            expireDate = NSDate(timeInterval: documents[0]["expires_in"] as! NSTimeInterval , sinceDate: documents[0]["date"] as! NSDate)
        }else{
            expireDate = NSDate(timeIntervalSinceNow: 100)
        }
        /**
        * 如果token过期了或第一次使用，进入认证界面
        * 否则进入主界面
        */
        if NSDate().compare(expireDate!) != NSComparisonResult.OrderedAscending || documents.count == 0 {
            performSegueWithIdentifier("showOauth", sender: self)
        }else{
            performSegueWithIdentifier("showMain", sender: self)
        }
    }
    
    /**
    切换选中状态
    */
    func selectShareButton(){
        shareButton.selected = !shareButton.selected
    }


}
