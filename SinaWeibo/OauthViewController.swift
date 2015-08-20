//
//  OauthViewController.swift
//  SinaWeibo
//
//  Created by baby on 15/8/19.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class OauthViewController: UIViewController , UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 建立一个URL请求，需要完整的URL地址，通过拼接完成
        let request = NSURLRequest(URL: NSURL(string:kAuthorizeBaseURL  + "?client_id=" + kAppKey + "&redirect_uri=" + kRedirectURL)!)
    
        webView.loadRequest(request)
        
    }

    /**
    WebView开始在入世显示loading
    */
    func webViewDidStartLoad(webView: UIWebView) {
        MBProgressHUD.showHUDAddedTo(view, animated: true).labelText = "正在加载..."
        
    }
    
    
    /**
    WebView结束载入时隐藏loading
    */
    func webViewDidFinishLoad(webView: UIWebView) {
        MBProgressHUD.hideHUDForView(view, animated: true)
    }
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        /// 取得请求的URL地址
        let urlStr = request.URL?.absoluteString
        /// 当URL中包含code=时，取出range
        let range = urlStr?.rangeOfString("code=")
        if range?.count > 0 {
            /// 通过rang的最后一位index来截取code=后面的内容
            let code = urlStr?.substringFromIndex((range?.endIndex)!)
            /**
            通过code来获取accessToken等数据
            */
            self.postForAccessToken(code!)
            /**
            不载入回调的网页（okjiaoyu.cn）
            */
            return false
        }
        
        return true
    }
    
    private func postForAccessToken(code:String){
        /// 参数
        let params = ["client_id":kAppKey,"client_secret":kAppSecret,"grant_type":"authorization_code","code":code,"redirect_uri":kRedirectURL]
        /// 用AFHTTP请求发起一个post请求
        let manager = AFHTTPRequestOperationManager()
        manager.POST("https://api.weibo.com/oauth2/access_token", parameters: params, success: { (operation:AFHTTPRequestOperation, responseObject:AnyObject) -> Void in
              print(responseObject)
            }) { (operation:AFHTTPRequestOperation, error:NSError) -> Void in
              print(error)
        }
        

        
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
