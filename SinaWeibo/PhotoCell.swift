//
//  PhotoCell.swift
//  SinaWeibo
//
//  Created by baby on 15/9/29.
//  Copyright © 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate{
    func colsePhoto()
}

///  照片浏览的 cell
class PhotoCell: UICollectionViewCell, UIScrollViewDelegate {
    
    /// 单张图片缩放的滚动视图
    var scrollView: UIScrollView?
    /// 显示图像的图像视图
    var imageView: UIImageView?
    var delegate:PhotoCellDelegate!
    
    ///  根据图像设置图像视图
    /**
    网络图片的类型
    - 长图
    - 短图
    
    1. 如何区分长图还是短图！
    - 都以宽度为基准缩放
    - 如果高度没有屏幕高，就是短图，垂直居中
    - 如果高度超出屏幕，就是长图，顶端对齐，方便滚动
    
    2. 图片缩放
    //imageView的图片缩放后才会自动根据图片大小改变contentsize。所以长图要先设置contentsize才能缩放。
    */
    
    
    func setupImageView(url: NSURL) {
        //  将 scrollView 的滚动参数重置
        scrollView?.zoomScale = 1
        var hud:MBProgressHUD?
        imageView!.sd_setImageWithURL(url, placeholderImage: nil, options: SDWebImageOptions(rawValue: 0), progress: { (_, _) -> Void in
        if hud == nil {
            hud = MBProgressHUD.showHUDAddedTo(self, animated: true)
        }
            }) { (_, _, _, _) -> Void in
            hud?.hide(true)
                self.configPhotoFrame()
        }
    }
    
    func configPhotoFrame(){
        // 1. 准备参数
        let imageSize = self.imageView?.image?.size
        let screenSize = self.bounds.size
        
        // 2. 按照宽度进行缩放，目标宽度 screenSize.width
        // 只需要计算目标高度
        let h = screenSize.width / imageSize!.width * imageSize!.height
        
        // 直接设置看结果
        let rect = CGRectMake(0, 0, screenSize.width, h)
        self.imageView!.frame = rect
        // 区分长图和短图
        if rect.size.height > screenSize.height {
            // 设置滚动区域
            self.scrollView!.frame = self.bounds
            self.scrollView!.contentSize = rect.size
        } else {
            // 需要垂直居中
            self.scrollView!.frame = self.bounds
            self.imageView!.center = CGPointMake(self.scrollView!.bounds.width/2, self.scrollView!.bounds.height/2)
        }
    }
    
    override func awakeFromNib() {
        //添加手势
        self.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "colsePhoto:")
        self.addGestureRecognizer(tap)
        // 创建界面元素
        scrollView = UIScrollView()
        contentView.addSubview(scrollView!)
        scrollView!.delegate = self
        scrollView!.maximumZoomScale = 2.0
        scrollView!.minimumZoomScale = 0.5
        
        // 图像视图，大小取决于传递的图像
        imageView = UIImageView()
        scrollView!.addSubview(imageView!)
    }
    
    //MARK: UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView!
    }
    

    func scrollViewDidZoom(scrollView: UIScrollView) {
        // 居中缩放
        let x = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0
        let y = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0
        imageView!.center = CGPointMake(scrollView.contentSize.width / 2 + x, scrollView.contentSize.height/2 + y)
        
    }
    
    //MARK: 点击照片的代理方法
    func colsePhoto(gesture:UIPinchGestureRecognizer){
       delegate.colsePhoto()
    }

}