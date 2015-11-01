//
//  PublishViewController.swift
//  SinaWeibo
//
//  Created by baby on 15/9/11.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class PublishViewController: UIViewController ,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var toolBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var publishButton: UIButton!
    lazy var photos:[UIImage] = []
    @IBOutlet weak var chooseImageButton: UIButton!
    
    lazy var composePhotosView:ComposePhotosView = ComposePhotosView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        publishButton.enabled = false
        placeholder.font = composeTextView.font
        composePhotosView.frame = CGRectMake(0, 100, kScreenWith, kScreenWith)
        composeTextView.addSubview(composePhotosView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillChangeFrameNotification, object:nil)
        composeTextView.becomeFirstResponder()

    }
    
    
    func keyboardShow(info:NSNotification){
        let height = info.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.height
        let duration = NSTimeInterval((info.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue)!)
        UIView.animateWithDuration(duration) { () -> Void in
            self.toolBarBottomConstraint.constant = height!
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text != "" {
            placeholder.hidden = true
            publishButton.enabled = true
        }else {
            placeholder.hidden = false
            publishButton.enabled = false
        }
        
        let textHeight = textView.subviews[0].frame.size.height//拿到输入文字的高度
        if textHeight > 100 {
            composePhotosView.frame.origin.y = textHeight + 5
        }else{
            composePhotosView.frame.origin.y = 100
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        composeTextView.resignFirstResponder()
        toolBarBottomConstraint.constant = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        composeTextView.resignFirstResponder()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)

    }
    
    @IBAction func composeImage(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .SavedPhotosAlbum
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if photos.count < 1 {
            photos.append(image)
            self.dismissViewControllerAnimated(true) { () -> Void in
                self.composePhotosView.image = image
                self.publishButton.enabled = true
                self.chooseImageButton.enabled = false
            }
        }
     
    }
    
    
    @IBAction func publishWeibo(sender: UIButton) {
        publishButton.enabled = false
        if photos.count == 0 {
            composeText()
        }else{
            composePhoto()
        }
       
    }
    
    private func composePhoto(){
        ComposeTool.composeWeiboWithPhoto(composeTextView.text, image: photos[0], sucess: { () -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            }) { (error) -> Void in
                self.publishButton.enabled = true
                print(error)
        }
    }
    
    private func composeText(){
        ComposeTool.composeWeiboWithText(composeTextView.text, sucess: { () -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            }) { (error) -> Void in
                self.publishButton.enabled = true
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
