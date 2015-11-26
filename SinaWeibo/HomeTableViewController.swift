//
//  HomeTableViewController.swift
//  SinaWeibo
//
//  Created by baby on 15/8/9.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit
import RealmSwift

class HomeTableViewController: UITableViewController,OverlayDelegate,PhotoItemDelegate{
    
    private var titleView:CustomTitleView!
    
    lazy var popMenuVC:PopMenuTableViewController = PopMenuTableViewController()
    
    var statuses:NSMutableArray?
    var statusesLocal:Results<StatusLocal>?
    
    var cellHeightCacheEnabled:Bool!
    
    let popTranstion = PopTransitionAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /**
        *  设置自动布局后，cell的高度自适应
        */
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setupNavagationBar()
        /**
        *  下拉刷新取最新微博
        */
        self.tableView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.getNewestWeibo()
            
        })
        self.tableView.header.beginRefreshing()//自动刷新
        /**
        *  获取更多微博
        */
        self.tableView.footer = MJRefreshAutoFooter(refreshingBlock: { () -> Void in
            self.getMoreWeibo()
        })
        
        
        
    }
    
    func refresh(){
        self.tableView.header.beginRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UserTool.getUserName({ (user:User) -> Void in
            
            self.titleView.setTitle(user.name!, forState: UIControlState.Normal)
            
            }) { (error) -> Void in
        }
    }
    
    
    /**
     获取最新微博
     */
    private func getNewestWeibo(){
        
        var sinceID:String?
        
        if let statuses = statuses {
            sinceID  = (statuses[0] as! Status).idstr!
        }
        
        StatusTool.newStatuses(sinceID, sucess: { (statuses) -> Void in
            if self.statuses == nil {
                self.statuses = statuses
                
                let realm = try! Realm()
                try! realm.write({ () -> Void in
                    realm.deleteAll()
                })
                
                for status in self.statuses!{
                    let status = status as! Status
                    let statusLocal = StatusLocal()
                    
                    let userLocal = UserLocal()
                    userLocal.name = (status.user?.name) ?? ""
                    userLocal.profile_image_url = status.user?.profile_image_url?.description
                    userLocal.mbtype = (status.user?.mbtype) ?? ""
                    userLocal.mbrank = (status.user?.mbrank) ?? ""
                    userLocal.isVip = (status.user?.isVip())!
                    
                    try! realm.write({ () -> Void in
                        realm.add(userLocal)
                    })
                    
                    
                    let retweetUserLocal = RetweetUserLocal()
                    retweetUserLocal.name = (status.retweeted_status?.user?.name) ?? ""
                    retweetUserLocal.profile_image_url = status.retweeted_status?.user?.profile_image_url?.description
                    retweetUserLocal.mbtype = (status.retweeted_status?.user?.mbtype) ?? ""
                    retweetUserLocal.mbrank = (status.retweeted_status?.user?.mbrank) ?? ""
                    retweetUserLocal.isVip = (status.retweeted_status?.user?.isVip()) ?? false
                    try! realm.write({ () -> Void in
                        realm.add(retweetUserLocal)
                    })
                    
                    
                    let retweetStatusLaocl = RetweetStatusLocal()
                    retweetStatusLaocl.text = status.retweeted_status?.text
                    retweetStatusLaocl.user = retweetUserLocal
                    try! realm.write({ () -> Void in
                        realm.add(retweetStatusLaocl)
                    })
                    
                    if let pics = status.pic_urls{
                        for pic in pics {
                            let photoLocal = PhotoLocal()
                            photoLocal.thumbnail_pic = (pic as! Photo).thumbnail_pic?.description
                            try! realm.write({ () -> Void in
                                realm.add(photoLocal)
                                statusLocal.pic_urls.append(photoLocal)
                            })
                        }
                    }
                    
                    statusLocal.created_at = status.created_at!
                    statusLocal.idstr = status.idstr!
                    statusLocal.text = status.text
                    statusLocal.source = status.source
                    statusLocal.retweeted_status = retweetStatusLaocl
                    statusLocal.user = userLocal
                    statusLocal.reposts_count = status.reposts_count
                    statusLocal.comments_count = status.comments_count
                    statusLocal.attitudes_count = status.attitudes_count
                    
                    
                    try! realm.write({ () -> Void in
                        realm.add(statusLocal)
                    })
                }
                
            }else if statuses.count != 0{
                let indexSet = NSIndexSet(indexesInRange: NSRange(location: 0, length: statuses.count))//插入的数量
                self.statuses!.insertObjects(statuses as [AnyObject], atIndexes: indexSet)//插入新微博在第0个位置
                
            }
            
            
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.tableView.header.endRefreshing()//结束刷新
                self.showNewCountLable(statuses.count)
                self.tableView.reloadData()
                (self.tabBarController as! MainTabBarController).requestUnreadCount()
            })
            
            }) { (error) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    let realm = try! Realm()
                    self.statusesLocal  = realm.objects(StatusLocal)
                    self.tableView.reloadData()
                    self.tableView.header.endRefreshing()//结束刷新
                })
        }
        
    }
    
    /**
     获取更多微博
     */
    private func getMoreWeibo(){
        
        guard let statuses =  statuses else{
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.mode = .Text
            hud.labelText = "当前无可用网络，请检查"
            hud.hide(true, afterDelay: 2)
            return
        }
        
        let maxID = UInt64((statuses.lastObject as! Status).idstr!)! - UInt64(1)//最大的微博ID转化成UINT64后减1
        let maxIDStr = String(maxID)
        
        StatusTool.moreStatuses(maxIDStr, sucess: { (Statuses) -> Void in
            statuses.addObjectsFromArray(Statuses as [AnyObject])
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.tableView.footer.endRefreshing()//结束刷新
                self.tableView.reloadData()
            })
            }, failure: { (error) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = .Text
                    hud.labelText = "没有更多微博了"
                    hud.hide(true, afterDelay: 2)
                    self.tableView.header.endRefreshing()//结束刷新
                })
        })
        
    }
    
    
    /**
     获取最新微博时浮窗提醒
     :param: count 获取的最新微博数
     */
    private func showNewCountLable(count:Int){
        
        if count == 0 {
            return
        }
        
        let h:CGFloat = 35
        let w = self.view.bounds.width
        let y = CGRectGetMaxY((self.navigationController?.navigationBar.frame)!) - CGFloat(35)
        
        let lable = UILabel(frame: CGRectMake(0, y, w, h))
        lable.text = "最新微博数\(count)条"
        lable.textAlignment = .Center
        lable.textColor = UIColor.whiteColor()
        lable.backgroundColor = UIColor(patternImage: UIImage(named: "timeline_new_status_background")!)
        
        self.navigationController?.view.insertSubview(lable, belowSubview: (self.navigationController?.navigationBar)!)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            lable.transform = CGAffineTransformMakeTranslation(0, h)
            }) { (_) -> Void in
                UIView.animateWithDuration(0.25, delay: 2, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    lable.transform = CGAffineTransformIdentity
                    }, completion: { (_) -> Void in
                        lable.removeFromSuperview()
                })
        }
        
    }
    
    /**
     配置导航栏按钮和title
     */
    private func setupNavagationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", highlightedImageName: "navigationbar_pop_highlighted", target: self, action: "pop", controllEvent: UIControlEvents.TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendsearch", highlightedImageName: "navigationbar_friendsearch_highlighted", target: self, action: "friendSearch", controllEvent: UIControlEvents.TouchUpInside)
        titleView = CustomTitleView(type: UIButtonType.Custom)
        
        let name = NSUserDefaults.standardUserDefaults().objectForKey("name") as? String ?? "首页"
        
        titleView.setTitle(name, forState: UIControlState.Normal)
        titleView.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        titleView.setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        titleView.adjustsImageWhenHighlighted = false
        titleView.addTarget(self, action: "showTitlePopmenu", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleView
    }
    
    /**
     点击title时显示弹出菜单
     */
    func showTitlePopmenu(){
        titleView.selected = !titleView.selected
        
        let overlay = CustomOverlay.show()
        overlay.delegate = self
        
        /// 显示Popmenu并设置大小，同时将popMenuVC的视图设置给contentView
        let popW:CGFloat = 200
        let popX:CGFloat = (self.view.bounds.size.width - 200) * 0.5
        let popH = popW
        let popY:CGFloat = 55
        let popMenu = CustomPopMenu.showInRect(CGRectMake(popX, popY, popW, popH))
        popMenu.contentView = popMenuVC.view
        
    }
    
    func didClickOverlay(overlay: CustomOverlay) {
        CustomPopMenu.hide()
        titleView.selected = false
    }
    
    /**
     右边按钮动作
     */
    func pop(){
        print("pop")
    }
    
    
    /**
     左边按钮动作
     */
    func friendSearch(){
        print("frinedSearch")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let statuses = statuses else{
            return statusesLocal?.count ?? 0
        }
        return statuses.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> StatusCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! StatusCell
        guard let statuses = statuses else{
//            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
//            hud.mode = .Text
//            hud.labelText = "当前无可用网络，请检查"
//            hud.hide(true, afterDelay: 2)
            if let statusesLocal = statusesLocal {
                let statusLocal = statusesLocal[indexPath.item]
                cell.statusesLocal = statusLocal
                cell.delegate = self
            }
            return cell
        }
        let status = statuses[indexPath.item] as! Status
        cell.status = status
        cell.delegate = self
        return cell
    }
    
    
    func photoDidClicked(photos:[AnyObject], indexPath: NSIndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let photoBrowser = storyBoard.instantiateViewControllerWithIdentifier("photo") as! PhotoCollectionViewController
        photoBrowser.transitioningDelegate = popTranstion
        var urls:[NSURL] = []
        for photo in photos {
            if let url = (photo as! Photo).thumbnail_pic {
                let urlStr = String(url).stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")//替换小图为中图
                let URL = NSURL(string: urlStr)
                urls.append(URL!)
            }
        }
        photoBrowser.imgUrls = urls
        photoBrowser.currentImageIndex = indexPath.item + 1//当前照片的索引从1开始
        self.presentViewController(photoBrowser, animated: true, completion: nil )
        
    }
    
    
}
