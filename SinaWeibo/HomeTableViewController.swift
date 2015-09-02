//
//  HomeTableViewController.swift
//  SinaWeibo
//
//  Created by baby on 15/8/9.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController,OverlayDelegate{
    
   
    
 
    private var titleView:CustomTitleView!
    
    lazy var popMenuVC:PopMenuTableViewController = PopMenuTableViewController()
    
    var statuses:NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setupNavagationBar()
        /**
        *  下拉刷新取最新微博
        */
        self.tableView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.getNewestWeibo()
            (self.tabBarController as! MainTabBarController).requestUnreadCount()
            
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
                fatalError()
        }
    }
    
    
    /**
    获取最新微博
    */
    private func getNewestWeibo(){
        
        var sinceID:String?
        
        if (statuses != nil) {
            sinceID  = (statuses[0] as! Status).idstr!
        }
        
        StatusTool.newStatuses(sinceID, sucess: { (statuses) -> Void in
            self.tableView.header.endRefreshing()//结束刷新
            if self.statuses == nil {
                self.statuses = statuses
            }else if statuses.count != 0{
                let indexSet = NSIndexSet(indexesInRange: NSRange(location: 0, length: statuses.count))//插入的数量
                self.statuses.insertObjects(statuses as [AnyObject], atIndexes: indexSet)//插入新微博在第0个位置
            }
            self.showNewCountLable(statuses.count)
            self.tableView.reloadData()
            
            }) { (error) -> Void in
                print(error)
        }
        
    }
    
    /**
    获取更多微博
    */
    private func getMoreWeibo(){
        
        guard (statuses != nil) else{
            fatalError()
        }
        
        let maxID = UInt64((statuses.lastObject as! Status).idstr!)! - UInt64(1)//最大的微博ID转化成UINT64后减1
        let maxIDStr = String(maxID)
        
        StatusTool.moreStatuses(maxIDStr, sucess: { (Statuses) -> Void in
            self.tableView.footer.endRefreshing()//结束刷新
            self.statuses.addObjectsFromArray(Statuses as [AnyObject])
            self.tableView.reloadData()
            }, failure: { (error) -> Void in
                print(error)
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
        if statuses == nil {
            return 0
        }else{
            return statuses.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> StatusCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! StatusCell
        
        guard let status = statuses[indexPath.row] as? Status else {
            fatalError("微博为空")
        }
        
        cell.name.text = status.user?.name
        //用SDwebimage加载图片
        cell.avatar.sd_setImageWithURL(status.user?.profile_image_url, placeholderImage: UIImage(named: "timeline_image_placeholder"))
                
        cell.statusText.text = status.text
        if status.retweeted_status != nil {
            if let retweetName = status.retweeted_status?.user?.name {
                cell.retweetText.text = "@" + retweetName + "：" + (status.retweeted_status!.text)!
            }
        }
        if let created_at = status.created_at {
            let createdDate = StringConvertTool.dateStringConverter(created_at)
            cell.createdDate.text = createdDate
        }
        
        if let source = status.source {
            let sourceString = StringConvertTool.sourceStringConverter(source)
            cell.source.text = sourceString
        }
        if let reposts_count = status.reposts_count where reposts_count != "0"{
            cell.retweetButton.setTitle(reposts_count, forState: UIControlState.Normal)
        }
        
        if let comments_count = status.comments_count where comments_count != "0"{
            cell.commentButton.setTitle(comments_count, forState: UIControlState.Normal)
        }
        if let attitudes_count = status.attitudes_count where attitudes_count != "0"{
            cell.likeButton.setTitle(attitudes_count, forState: UIControlState.Normal)
        }
        
        if status.user!.isVip() {
            cell.vipIcon.image = UIImage(named: "common_icon_membership")
            cell.name.textColor = UIColor.orangeColor()
        }else{
            cell.vipIcon.image = nil
            cell.name.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
