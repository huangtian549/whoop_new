//
//  YRNewPostImageViewController.swift
//  Whoop
//
//  Created by 刘乃坤 on 15/4/23.
//  Copyright (c) 2015年 Li Jiatan. All rights reserved.
//
import UIKit


protocol YRDeleteImageViewDelegate
{
    // @optional func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    
    func deleteImageView(imageView:UIImageView, i:Int)
}


class YRNewPostImageViewController: UIViewController {

    var imageView:UIImageView!
    var i:Int!   //图片在图片数组中的位置
    var delegate:YRDeleteImageViewDelegate!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        self.title = "Detail"

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var navigationBar:UINavigationBar = UINavigationBar(frame: CGRectMake(0, 69, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        let navigationItem:UINavigationItem = UINavigationItem(title: "Photo")
        let btn = UIBarButtonItem(title: "删除", style: UIBarButtonItemStyle.Plain, target: self, action: "deleteImageClick")
        navigationItem.rightBarButtonItem = btn
        navigationBar.pushNavigationItem(navigationItem, animated: true)
        self.view.addSubview(navigationBar)
        
          imageViewTapped()
    }
    
    func deleteImageClick(){
        self.delegate.deleteImageView(self.imageView,i: self.i)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageViewTapped()
    {
        var image = self.imageView.image
        var window = UIApplication.sharedApplication().keyWindow
        var backgroundView = UIView(frame: CGRectMake(0, 69, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        backgroundView.backgroundColor = UIColor.blackColor()
        backgroundView.alpha = 0
        var imageView = UIImageView(frame: self.imageView.frame)
        
        imageView.image = image
        //        imageView.tag = i + 1
        backgroundView.addSubview(imageView)
        window?.addSubview(backgroundView)
        var hide = UITapGestureRecognizer(target: self, action: "hideImage:")
        
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(hide)
        UIView.animateWithDuration(0.3, animations:{ () in
            var vsize = UIScreen.mainScreen().bounds.size
            imageView.frame = CGRect(x:0.0, y: 0.0, width: vsize.width, height: vsize.height)
            imageView.contentMode = .ScaleAspectFit
            backgroundView.alpha = 1
            }, completion: {(finished:Bool) in })
        
        
    }
    
    func hideImage(sender: UITapGestureRecognizer){
        var i:Int = sender.view!.tag
        var backgroundView = sender.view as UIView?
        if let view = backgroundView{
            UIView.animateWithDuration(0.1,
                animations:{ () in
                    var imageView = view.viewWithTag(i) as! UIImageView
                    imageView.frame = self.imageView.frame
                    imageView.alpha = 0
                    
                },
                completion: {(finished:Bool) in
                    view.alpha = 0
                    view.superview?.removeFromSuperview()
                    view.removeFromSuperview()
            })
        }
    }

    
}
