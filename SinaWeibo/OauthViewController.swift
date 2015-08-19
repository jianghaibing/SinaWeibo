//
//  OauthViewController.swift
//  SinaWeibo
//
//  Created by baby on 15/8/19.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class OauthViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let baseURL = "https://api.weibo.com/oauth2/authorize"
        let appKey = "2409286304"
        let redirectURL = "http://www.okjiaoyu.cn"
        
        let request = NSURLRequest(URL: NSURL(string: baseURL + "?client_id=" + appKey + "&redirect_uri=" + redirectURL)!)
    
        webView.loadRequest(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
