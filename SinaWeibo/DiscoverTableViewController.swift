//
//  DiscoverTableViewController.swift
//  SinaWeibo
//
//  Created by baby on 15/8/9.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class DiscoverTableViewController: UITableViewController,UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 在titleView上添加搜索框
        let searchBar = CustomSearchBar(frame: CGRectMake(0, 0, kScreenWith, 35))
        searchBar.placeholder = "大家都在搜"
        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
