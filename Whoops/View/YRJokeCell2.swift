//
//  YRJokeCell2.swift
//  Whoop
//
//  Created by djx on 15/5/22.
//  Copyright (c) 2015年 Li Jiatan. All rights reserved.
//

import UIKit

var textYpostion:CGFloat = 0;

class YRJokeCell2: UITableViewCell {

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setCellUp(data:NSDictionary)
    {
        for view : AnyObject in self.subviews
        {
            view.removeFromSuperview();
        }
        
        self.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0);
        //背景图片
        var ivBack = UIImageView(frame:CGRectMake(10, 7, frame.size.width - 20, 187));
        ivBack.backgroundColor = UIColor.whiteColor();
        ivBack.layer.shadowOffset = CGSizeMake(10, 10);
        ivBack.layer.shadowColor = UIColor(red:237.0/255.0 , green:237.0/255.0, blue:237.0/255.0 , alpha: 1.0).CGColor;
        self.addSubview(ivBack);
        
        //收藏按钮
        var fav = UIButton(frame:CGRectMake(3, 3, 24, 24));
        fav.setImage(UIImage(named:"star"), forState: UIControlState.Normal);
        fav.addTarget(self, action: "btnFavClick:", forControlEvents: UIControlEvents.TouchUpInside);
        ivBack.addSubview(fav);
        
        //设置图片
        var imageStr = data.stringAttributeForKey("image") as NSString; //"/data/20150317/82419456-f5a7-458c-ae32-c4bdeb503da5.jpg,/data/20150317/82419456-f5a7-458c-ae32-c4bdeb503da5.jpg,/data/20150317/82419456-f5a7-458c-ae32-c4bdeb503da5.jpg";//
        var imgArray = imageStr.componentsSeparatedByString(",") as NSArray;
        var height:CGFloat = 160; //图片区域的高度
        var offset:CGFloat = 5; //图片偏移区
        var xPositon:CGFloat = 5;
        var yPosition:CGFloat = 33;
        var width:CGFloat;
        width = (CGFloat)(ivBack.frame.size.width - 55); //图片区域的宽度
        
        
        
        if(imgArray.count > 0)
        {
            if (imgArray.count == 1)
            {
                //只有一张图片,高度应该小于宽度，以高度为准，居中显示
                var img0 = UIImageView(frame:CGRectMake((width - height)/2, yPosition, height, height));
                
                ivBack.addSubview(img0);
                var imgUrl = imgArray.objectAtIndex(0) as! NSString;
                if(imgUrl.length <= 0)
                {
                    img0.image = UIImage(named: "Logoo.png");
                }
                else
                {
                    var imagURL = FileUtility.getUrlImage() + (imgUrl as String);
                    img0.setImage(imagURL,placeHolder: UIImage(named: "Logoo.png"));
                }
                
                textYpostion = height + yPosition;
                
            }
            else if(imgArray.count == 2)
            {
                //2张图片
                var widthTmp:CGFloat;
                widthTmp = (CGFloat)(width - offset)/2;
                var imgWidth:CGFloat;
                imgWidth = height>widthTmp ? widthTmp:height;
                var index = 0
                for imgUrl in imgArray
                {
                    var x:CGFloat;
                     x = xPositon + CGFloat(index * Int(imgWidth + offset));
                    var imgView = UIImageView(frame:CGRectMake(x, yPosition, imgWidth, imgWidth));
                    imgView.userInteractionEnabled = true
//                    var tap = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
//                    imgView.addGestureRecognizer(tap)
                    var imagURL = FileUtility.getUrlImage() + (imgUrl as! String)
                    imgView.tag = index;
                    imgView.setImage(imagURL,placeHolder: UIImage(named: "Logoo.png"))
                    index++;
                    ivBack.addSubview(imgView);
                    
                }
                
                textYpostion = imgWidth + yPosition;
            }
            else if(imgArray.count >= 3)
            {
                //3张图片及以上
                var widthTmp:CGFloat;
                widthTmp = (CGFloat)(width - 2*offset)/3;
                var index = 0
                for imgUrl in imgArray
                {
                    var x:CGFloat;
                    x = xPositon + CGFloat(index%3 * Int(widthTmp + offset));
                    var y:CGFloat;
                    y = yPosition + CGFloat(index/3 * Int(widthTmp + offset));
                    var imgView = UIImageView(frame:CGRectMake(x , y, widthTmp, widthTmp));
                    imgView.userInteractionEnabled = true
                    //                    var tap = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
                    //                    imgView.addGestureRecognizer(tap)
                    var imagURL = FileUtility.getUrlImage() + (imgUrl as! String)
                    imgView.tag = index;
                    imgView.setImage(imagURL,placeHolder: UIImage(named: "Logoo.png"))
                    index++;
                    ivBack.addSubview(imgView);
                }
                
                textYpostion = yPosition + CGFloat(index/3 * Int(widthTmp + offset));
            }
        }
        
        var lableContent = UILabel(frame: CGRectMake(3, textYpostion + 5, ivBack.frame.size.width-6, 100));
        lableContent.numberOfLines = 0;
        lableContent.textColor = UIColor(red:60.0/255.0 , green:60.0/255.0 , blue: 60.0/255.0, alpha: 1.0);
        lableContent.font = UIFont.systemFontOfSize(13);
        var text = data.stringAttributeForKey("content");
        
        lableContent.text = text as String;
        let size = text.stringHeightWith(13,width:lableContent.frame.size.width);
        var rect = lableContent.frame as CGRect;
        rect.size.height = size;
        lableContent.frame = rect;
        ivBack.addSubview(lableContent);
        
        var rectBack = ivBack.frame as CGRect;
        rectBack.size.height = textYpostion+size + 50;
        ivBack.frame = rectBack;
        
        //喜欢按钮
        var like = UIButton(frame:CGRectMake(ivBack.frame.size.width-36, ((textYpostion - yPosition)/3 - 17)/2 + yPosition, 17, 17));
        like.setImage(UIImage(named:"Like"), forState: UIControlState.Normal);
        like.addTarget(self, action: "btnLikeClick:", forControlEvents: UIControlEvents.TouchUpInside);
        ivBack.addSubview(like);
        
        //喜欢数量
        var likeNum = UILabel(frame: CGRectMake(ivBack.frame.size.width-52, (textYpostion - yPosition)/3 + ((textYpostion - yPosition)/3 - 17)/2 + yPosition, 50, 17));
        likeNum.textAlignment = NSTextAlignment.Center;
        likeNum.textColor = UIColor(red:121.0/255.0 , green:122.0/255.0 , blue:124.0/255.0 , alpha: 1.0);
        if (data.stringAttributeForKey("likeNum") == NSNull())
        {
            likeNum.text = "0";
        }
        else
        {
            likeNum.text = data.stringAttributeForKey("likeNum");
        }
        ivBack.addSubview(likeNum);
        
        //不喜欢
        var unlike = UIButton(frame:CGRectMake(ivBack.frame.size.width-36, 2*(textYpostion - yPosition)/3+((textYpostion - yPosition)/3 - 17)/2 + yPosition, 17, 17));
        unlike.setImage(UIImage(named:"close"), forState: UIControlState.Normal);
        unlike.addTarget(self, action: "btnUnLikeClick:", forControlEvents: UIControlEvents.TouchUpInside);
        ivBack.addSubview(unlike);
        
        //设置底部数据
        var viewBottom = UIView(frame: CGRectMake(0, textYpostion+size + 10, ivBack.frame.size.width, 35));
        viewBottom.backgroundColor = UIColor(red:244.0/255.0 , green:244.0/255.0 , blue:244.0/255.0 , alpha: 1.0);
        ivBack.addSubview(viewBottom);
        
        var imgTime = UIImageView(frame: CGRectMake(5, 9, 16, 16));
        imgTime.image = UIImage(named: "time");
        viewBottom.addSubview(imgTime);
        
        var createDateLabel = UILabel(frame: CGRectMake(25, 9, 30, 16));
        createDateLabel.textColor = UIColor(red:149.0/255.0 , green:149.0/255.0 , blue:149.0/255.0 , alpha: 1.0);
        createDateLabel.font = UIFont.systemFontOfSize(13);
        createDateLabel.text = data.stringAttributeForKey("createDateLabel") as String;
        viewBottom.addSubview(createDateLabel);
        
        var commentCount = UILabel(frame: CGRectMake(55, 9, 70, 16));
        commentCount.textColor = UIColor(red:149.0/255.0 , green:149.0/255.0 , blue:149.0/255.0 , alpha: 1.0);
        commentCount.font = UIFont.systemFontOfSize(13);
        commentCount.textAlignment = NSTextAlignment.Center;
        commentCount.text = data.stringAttributeForKey("commentCount") as String + " Replies";
        viewBottom.addSubview(commentCount);
        
        var  imgNick = UIImageView(frame: CGRectMake(155, 9, 16, 16));
        imgNick.image = UIImage(named: "ballonHighlight");
        viewBottom.addSubview(imgNick);
        
        var nickName = UILabel(frame: CGRectMake(177, 9, ivBack.frame.width - 180, 16));
        nickName.textColor = UIColor(red:149.0/255.0 , green:149.0/255.0 , blue:149.0/255.0 , alpha: 1.0);
        nickName.font = UIFont.systemFontOfSize(13);
        nickName.text = data.stringAttributeForKey("nickName") as String;
        viewBottom.addSubview(nickName);
    }
    
    
    func btnFavClick(sender:UIButton)
    {
        
    }
    
    func btnLikeClick(sender:UIButton)
    {
        
    }
    
    func btnUnLikeClick(sender:UIButton)
    {
        
    }
    
    class func cellHeightByData(data:NSDictionary)->CGFloat
    {
        let mainWidth = UIScreen.mainScreen().bounds.width
        var lableContent = UILabel(frame: CGRectMake(3, 193, mainWidth - 26, 100));
        lableContent.numberOfLines = 0;
        lableContent.font = UIFont.systemFontOfSize(13);
        var text = data.stringAttributeForKey("content");
        let size = text.stringHeightWith(13,width:mainWidth - 26);
        return textYpostion + size+50;

    }
    
}
