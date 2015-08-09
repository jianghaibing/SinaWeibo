//
//  HomeTableViewController.swift
//  SinaWeibo
//
//  Created by baby on 15/8/9.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController,CZCoverDelegate {
    
    var titleView:CustomTitleView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavagationBar()
        
    }
    
    
    /**
    配置导航栏按钮和title
    */
    func setupNavagationBar(){
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
        let menu1 = KxMenuItem("首页           ", image: nil, target: self, action: nil)
        let menu2 = KxMenuItem("好友圈         ", image: nil, target: self, action: nil)
        let menu3 = KxMenuItem("微博群         ", image: nil, target: self, action: nil)
        let menu4 = KxMenuItem("我的微博        ", image: nil, target: self, action: nil)
        let frame = CGRectMake(titleView.frame.origin.x, titleView.frame.origin.y + titleView.bounds.height, titleView.bounds.width, titleView.bounds.height)
        KxMenu.showMenuInView(self.view.window, fromRect:frame, menuItems: [menu1,menu2,menu3,menu4])
        KxMenu.setTintColor(UIColor(red: 95/255, green: 95/255, blue: 95/255, alpha: 0.3))
        let overlay = self.view.window?.subviews[1] as? KxMenuOverlay
        overlay?.delegate = self
        
    }

    func coverDidClickCover(cover: KxMenuOverlay!) {
        titleView.selected = !titleView.selected
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
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
