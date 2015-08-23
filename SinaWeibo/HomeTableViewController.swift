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
    
    /**
    获取最新微博
    */
    private func getNewestWeibo(){
        let manger = AFHTTPRequestOperationManager()
        var params = ["access_token":Account.shareInstance.token!]
        if (statuses != nil){
            params["since_id"] = (statuses[0] as! Status).idstr
        }
        manger.GET("https://api.weibo.com/2/statuses/friends_timeline.json", parameters: params, success: { (request:AFHTTPRequestOperation, result:AnyObject) -> Void in
            self.tableView.header.endRefreshing()//结束刷新
            let dictArry = result["statuses"]//取到最新微博数组
            let newStatus:NSMutableArray = Status.objectArrayWithKeyValuesArray(dictArry)//数组字典转模型
            let indexSet = NSIndexSet(indexesInRange: NSRange(location: 0, length: newStatus.count))//插入的数量
            if self.statuses == nil {
                self.statuses = newStatus
            }else{
                self.statuses.insertObjects(newStatus as [AnyObject], atIndexes: indexSet)//插入新微博在第0个位置
            }
        
            self.tableView.reloadData()
            }) { (request:AFHTTPRequestOperation, error:NSError) -> Void in
                print(error)
        }
    }
    
    /**
    获取更多微博
    */
    
    private func getMoreWeibo(){
        
            if (statuses != nil){
            let manger = AFHTTPRequestOperationManager()
            var params = ["access_token":Account.shareInstance.token!]
            let maxID = UInt64((statuses.lastObject as! Status).idstr!)! - UInt64(1)//最大的微博ID转化成UINT64后减1
            params["max_id"] = String(maxID)
            
            manger.GET("https://api.weibo.com/2/statuses/friends_timeline.json", parameters: params, success: { (request:AFHTTPRequestOperation, result:AnyObject) -> Void in
                self.tableView.footer.endRefreshing()//结束刷新
                let dictArry = result["statuses"]//取到更多微博数组
                let moreStatuses:NSMutableArray = Status.objectArrayWithKeyValuesArray(dictArry)//数组字典转模型
                
                self.statuses.addObjectsFromArray(moreStatuses as [AnyObject])
                
                self.tableView.reloadData()
                }) { (request:AFHTTPRequestOperation, error:NSError) -> Void in
                    print(error)
            }

        }
    }
    
    /**
    配置导航栏按钮和title
    */
    private func setupNavagationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", highlightedImageName: "navigationbar_pop_highlighted", target: self, action: "pop", controllEvent: UIControlEvents.TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendsearch", highlightedImageName: "navigationbar_friendsearch_highlighted", target: self, action: "friendSearch", controllEvent: UIControlEvents.TouchUpInside)
        titleView = CustomTitleView(type: UIButtonType.Custom)
        titleView.setTitle("首页", forState: UIControlState.Normal)
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

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let status = statuses[indexPath.row] as? Status
        cell.textLabel?.text = status?.user?.name
        //用SDwebimage加载图片
        cell.imageView?.sd_setImageWithURL(status?.user?.profile_image_url, placeholderImage: UIImage(named: "timeline_image_placeholder"))
        cell.detailTextLabel?.text = status?.text

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
