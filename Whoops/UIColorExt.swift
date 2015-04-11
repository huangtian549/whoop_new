//
//  UIColorExt.swift
//  Whoop
//
//  Created by alidao3 on 15/4/9.
//  Copyright (c) 2015年 Li Jiatan. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    //主题色
    class func applicationMainColor() -> UIColor {
        return UIColor(red: 42/255, green: 126/255, blue: 212/255, alpha:1)
    }
    
    //第二主题色
    class func applicationSecondColor() -> UIColor {
        return UIColor.lightGrayColor()
    }
    
    //警告颜色
    class func applicationWarningColor() -> UIColor {
        return UIColor(red: 0.1, green: 1, blue: 0, alpha: 1)
    }
    
    //链接颜色
    class func applicationLinkColor() -> UIColor {
        return UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha:1)
    }
    
    class func applicationTabBarColor() -> UIColor {
        return UIColor(red: 242/255, green: 244/255, blue: 245/255, alpha:1)
    }
}
