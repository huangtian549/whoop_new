//
//  MainViewController.swift
//  Whoops
//
//  Created by huangyao on 15-2-26.
//  Copyright (c) 2015年 Li Jiatan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation



class YRMainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate, YRRefreshViewDelegate{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //@IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    let identifier = "cell"
    //    var tableView:UITableView?
    var dataArray = NSMutableArray()
    var page :Int = 1
    var refreshView:YRRefreshView?
    let locationManager: CLLocationManager = CLLocationManager()
    
    var lat:Double = 0
    var lng:Double = 0
    var school:Int = 0
    var userId:String = "0"
    
    var type:Int = 0
    
    let itemArray = ["最新","最热","收藏","历史最热"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if(ios8()){
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
        }
        locationManager.startUpdatingLocation()
        userId = FileUtility.getUserId()
        setupViews()
        // self.hotClick();
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "imageViewTapped", object:nil)
        
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageViewTapped:", name: "imageViewTapped", object: nil)
    }
    
    
    
    func setupViews()
    {
        var width = self.view.frame.size.width
        var height = self.view.frame.size.height
        //        self.tableView = UITableView(frame:CGRectMake(0,0,width,height-49))
        self.tableView!.delegate = self;
        self.tableView!.dataSource = self;
        
        var myTabbar :UIView = UIView(frame: CGRectMake(0,49,width,49))
        myTabbar.backgroundColor = UIColor.blueColor()
        self.view.addSubview(myTabbar)
        
        var count = itemArray.count
        
        for var index = 0; index < count; index++
        {
            var btnWidth = (CGFloat)(index*80)
            var button  = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            button.frame = CGRectMake(btnWidth, 0,80,49)
            button.tag = index+100
            var title = itemArray[index]
            button.setTitle(title, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            
            button.addTarget(self, action: "tabBarButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            myTabbar.addSubview(button)
            if index == 0
            {
                button.selected = true
            }
        }
        
        
        
        var nib = UINib(nibName:"YRJokeCell", bundle: nil)
        
        self.tableView?.registerNib(nib, forCellReuseIdentifier: identifier)
        // self.tableView?.registerClass(YRJokeCell.self,
        //forCellReuseIdentifier: identifier)
        var arr =  NSBundle.mainBundle().loadNibNamed("YRRefreshView" ,owner: self, options: nil) as Array
        self.refreshView = arr[0] as? YRRefreshView
        self.refreshView!.delegate = self
        
        self.tableView!.tableFooterView = self.refreshView
        self.view.addSubview(self.tableView!)
        
        self.addRefreshControl()
    }
    
    
    func addRefreshControl(){
        var fresh:UIRefreshControl = UIRefreshControl()
        fresh.addTarget(self, action: "actionRefreshHandler:", forControlEvents: UIControlEvents.ValueChanged)
        fresh.tintColor = UIColor.redColor()
        fresh.attributedTitle = NSAttributedString(string: "reloading")
        self.tableView?.addSubview(fresh)
    }
    
    func actionRefreshHandler(sender:UIRefreshControl){
        page = 1
        var url = urlString(self.type)
        self.refreshView!.startLoading()
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as! NSObject == NSNull()
            {
                UIView.showAlertView("Alert",message:"Loading Failed")
                return
            }
            
            var arr = data["data"] as! NSArray
            
            self.dataArray = NSMutableArray()
            for data : AnyObject  in arr
            {
                self.dataArray.addObject(data)
                
            }
            self.page++
            self.tableView!.reloadData()
            self.refreshView!.stopLoading()
            
            sender.endRefreshing()
        })
        
    }
    
    func loadData(type:Int)
    {
        var url = urlString(type)
        self.refreshView!.startLoading()
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as! NSObject == NSNull()
            {
                UIView.showAlertView("Alert",message:"Loading Failed")
                return
            }
            
            var arr = data["data"] as! NSArray
            
            if self.page == 1 {
                self.dataArray = NSMutableArray()
            }
            
            for data : AnyObject  in arr
            {
                self.dataArray.addObject(data)
            }
            self.tableView!.reloadData()
            self.refreshView!.stopLoading()
            self.page++
        })
        
    }
    
    
    func urlString(type:Int)->String
    {
        var url:String = FileUtility.getUrlDomain()
        if(school == 0){
            if type == 0 {
                url += "post/listNewByLocation?latitude=\(lat)&longitude=\(lng)&pageNum=\(page)"
            }else if (type == 1){
                url += "post/listHotByLocation?latitude=\(lat)&longitude=\(lng)&pageNum=\(page)"
            }else if (type == 2){
                url += "favorPost/list?uid=\(FileUtility.getUserId())&pageNum=\(page)"
            }else {
                url += "post/listHotAll?pageNum=\(page)"
            }
        }else{
            if type == 0 {
                url += "post/listNewBySchool?schoolId=\(school)&pageNum=\(page)"
            }else if (type == 1){
                url += "post/listHotBySchool?schoolId=\(school)&pageNum=\(page)"
            }else if (type == 2){
                url += "favorPost/list?uid=\(FileUtility.getUserId())&pageNum=\(page)"
            }else {
                url += "post/listHotAll?pageNum=\(page)"
            }
        }
        
        return url
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.dataArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? YRJokeCell
        var index = indexPath.row
        var data = self.dataArray[index] as! NSDictionary
        cell!.data = data
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        var index = indexPath.row
        var data = self.dataArray[index] as! NSDictionary
        return  YRJokeCell.cellHeightByData(data)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var index = indexPath.row
        var data = self.dataArray[index] as! NSDictionary
        var commentsVC = YRCommentsViewController(nibName :nil, bundle: nil)
        commentsVC.jokeId = data.stringAttributeForKey("id")
        commentsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentsVC, animated: true)
        
        //    self.performSegueWithIdentifier("showComment", sender:data.stringAttributeForKey("id"))
        
    }
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        var postId:String = sender as String;
    //
    //        var commentViewController:YRCommentsViewController =  segue.destinationViewController as YRCommentsViewController;
    //        commentViewController.postId = postId
    //    }
    
    
    
    
    func refreshView(refreshView:YRRefreshView,didClickButton btn:UIButton)
    {
        //refreshView.startLoading()
        loadData(self.type)
    }
    
    func imageViewTapped(noti:NSNotification)
    {
        
        var imageURL = noti.object as! String
        var imgVC = YRImageViewController(nibName: nil, bundle: nil)
        imgVC.imageURL = imageURL
        self.navigationController?.pushViewController(imgVC, animated: true)
        
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        
        var location:CLLocation = locations[locations.count-1] as! CLLocation
        
        if (location.horizontalAccuracy > 0) {
            lat = location.coordinate.latitude
            lng = location.coordinate.longitude
            loadData(self.type)
            self.locationManager.stopUpdatingLocation()
            
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
        //        self.textLabel.text = "get location error"
    }
    
    
    func tabBarButtonClicked(sender:UIButton)
    {
        var index = sender.tag
        
        for var i = 0;i<4;i++
        {
            var button = self.view.viewWithTag(i+100) as! UIButton
            if button.tag == index
            {
                button.selected = true
            }
            else
            {
                button.selected = false
            }
        }
        
        //        UIView.animateWithDuration( 0.3,
        //            animations: {
        //
        //                self.slider!.frame = CGRectMake(CGFloat(index-100)*80,0,80,49)
        //
        //        })
        //self.title = itemArray[index-100] as String
        page = 1
        self.dataArray = NSMutableArray()
        self.type = index - 100
        loadData(index-100)
        
    }
    
    
    //    @IBAction func hotClick(){
    //        var selectIndex = segmentedControl.selectedSegmentIndex
    //        if selectIndex == 1{
    //            self.type = "hot"
    //            page = 1
    //            self.dataArray = NSMutableArray()
    //            loadData("hot")
    //        }else{
    //            self.type = "new"
    //            page = 1
    //            self.dataArray = NSMutableArray()
    //            loadData("new")
    //        }
    //    }
    
    func ios8()->Bool{
        let version:NSString = UIDevice.currentDevice().systemVersion
        let bigVersion = version.substringToIndex(1)
        let intBigVersion = bigVersion.toInt()
        if intBigVersion >= 8 {
            return true
        }else {
            return false
        }
        
    }
    
    
}
