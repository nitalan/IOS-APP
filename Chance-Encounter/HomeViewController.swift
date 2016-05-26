//
//  ViewController.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/2/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MPCManagerDelegate{
    
    
    @IBOutlet weak var homeTable: UITableView!
    let basicCellIdentifier = "BasicCell"
    let imageCellIdentifier = "ImageCell"
     var connectManager:ConnectManager?
    let blogSegueIdentifier = "ShowDetail"
     let blogSegueIdentifier2 = "ShowDetail2"
    
    var feeds = [Feed]()
    var votes = [Vote]()
    var connectedUsers = [String]()
    
    func foundPeer() {
       
        connectedUsers=[]
        let selectedPeer = connectManager!.foundPeers as [MCPeerID]
        for peer in selectedPeer{
            connectedUsers.append(peer.displayName)
        }
        loadSampleFeeds()
        self.homeTable.reloadData()
        dispatch_async(dispatch_get_main_queue(),{
            self.homeTable.reloadData()
        });
    }
    
    
    func lostPeer() {
        connectedUsers=[]
        let selectedPeer = connectManager!.foundPeers as [MCPeerID]
        for peer in selectedPeer{
            connectedUsers.append(peer.displayName)
        }
       // print("yes")
        loadSampleFeeds()
        self.homeTable.reloadData()
        dispatch_async(dispatch_get_main_queue(),{
            self.homeTable.reloadData()
        });
    }
    
    func invitationWasReceived(fromPeer: String) {
        
    }
    
    func displayMyAlertMessage(userMessage:String)
    {
        let MyAlert = UIAlertController(title:"Alert",message:userMessage,preferredStyle:UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.Default,handler:nil)
        
        MyAlert.addAction(okAction)
        self.presentViewController(MyAlert,animated:true,completion:nil);
    }
    
    
    
    
    
    func loadSampleFeeds() {
        
        feeds = [Feed]()
        
        
        
        var jsonData:NSData?
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(connectedUsers, options: NSJSONWritingOptions.PrettyPrinted)
        }catch let error as NSError{
            //print(error.description)
        }
        let poststring = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)
        
        let myUrl = NSURL(string:"http://45.33.44.105/jiaowen.com/ShowFeeds.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod="POST";
        
        //compose a query string
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let postString = "username=\(prefs.valueForKey("USERNAME") as! String)&usernames=\(poststring!)";
        
        //var feed7 = Feed( textView: " ", currentTime: " " )
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                
                data,response,error in
                
                if error != nil
                {
                    print("error=\(error)")
                    return
                }
                
                // You can print out response object
                
                //print("response = \(response)")
                
                // Print out response body
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //print("responseString = \(responseString)")
                
                //var err: NSError?
                
                let json = try!NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                if let parseJSON = json
                {
                    // Now we can access value of status by its key
                    //let resultValue = parseJSON["status"] as? String
                    let getFeeds = parseJSON["feeds"] as? NSArray
                    if getFeeds==nil{
                        return
                    }
                    let success = parseJSON["status"] as! Int
                    
                    if(success==0){
                        return
                    }
                    
                    for items in getFeeds!
                    {
                        let id = items.objectAtIndex(0)  as! String
                        let username = items.objectAtIndex(1) as! String
                        let des = items.objectAtIndex(2) as! String
                        let time = items.objectAtIndex(3)as! String
                        let commentSize = items.objectAtIndex(4) as! String
                        let voteNum = items.objectAtIndex(5) as! String
                        let image = items.objectAtIndex(6) as! String
                        //                        let decodedData = NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                        //                        let decodedimage = UIImage(data: decodedData!)
                        // println(decodedimage)
                        //yourImageView.image = decodedimage as UIImage
                        
                        let feedx = Feed(id: Int(id)!, username: username,textView: des,currentTime: time,feeds_commentSize: Int(commentSize)!,voteNum:Int(voteNum)!,photoView:image)!
                        self.feeds.append(feedx)
                        
                    }
                    let getFeedFollow = parseJSON["feedsFollow"] as? NSArray
                    
                    if getFeedFollow != nil {
                        for items2 in getFeedFollow!
                        {
                            let vote_person = items2.objectAtIndex(1) as! String
                            let vote_feed = items2.objectAtIndex(2) as! String
                            let value = items2.objectAtIndex(3) as! String
                            let votex = Vote(vote_person:vote_person, vote_feed: Int(vote_feed)!, value:Int(value)!)!
                            self.votes.append(votex)
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                        // 回调或者说是通知主线程刷新，text
                        // sleep(5)
                        self.homeTable.reloadData()
                    });
                }
                
        }
        
        task.resume()
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //print("bbb")
        
        homeTable.delegate = self
        homeTable.dataSource = self
        self.homeTable.rowHeight = 170;
        
        connectManager = ConnectManager()
        connectManager!.delegate = self
        
        connectManager!.browser.startBrowsingForPeers()
        
        connectManager!.advertiser.startAdvertisingPeer()
        
        //self.displayMyAlertMessage("bbbb2" + (prefs.valueForKey("USERNAME") as! String)+"^" )
       // self.automaticallyAdjustsScrollViewInsets = false
        //print("bbb2")
    }
    
    override func viewDidAppear(animated: Bool) {
        var str = "hello"+String(connectedUsers.count)+","
        for s in connectedUsers{
            str += s+","
        }
        //self.displayMyAlertMessage(str)
    }
    
    override func viewWillAppear(animated: Bool) {
        //print("fff")
        
        loadSampleFeeds()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.homeTable.reloadData()
            self.homeTable.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        })
        
    }
    
    
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLogged")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        connectManager!.browser.stopBrowsingForPeers()
        
        connectManager!.advertiser.stopAdvertisingPeer()
        
        
        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginViewController
        
        appDelegate.window?.makeKeyAndVisible()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if feeds.isEmpty {
            let cell = self.homeTable.dequeueReusableCellWithIdentifier(basicCellIdentifier) as! BasicCell
            return cell
        }
        
        if hasImageAtIndexPath(indexPath) {
            
            return imageCellAtIndexPath(indexPath)
            
        } else {
            
            
            return basicCellAtIndexPath(indexPath)
        }
    }
    
    func hasImageAtIndexPath(indexPath:NSIndexPath) -> Bool {
       // print(indexPath.row)
        //print(feeds.count)
        let feed = feeds[indexPath.row]
        if(feed.photoView.isEmpty){
            return false
        }
        return true
    }
    
    func basicCellAtIndexPath(indexPath:NSIndexPath) -> BasicCell {
        let cell = self.homeTable.dequeueReusableCellWithIdentifier(basicCellIdentifier) as! BasicCell
        setContentForCell(cell, indexPath: indexPath)
        setTimeForCell(cell, indexPath: indexPath)
        setRepliesForCell(cell, indexPath: indexPath)
        setVoteNumberForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func imageCellAtIndexPath(indexPath:NSIndexPath) -> ImageCell {
        let cell = self.homeTable.dequeueReusableCellWithIdentifier(imageCellIdentifier) as! ImageCell
        setImageForCell(cell, indexPath: indexPath)
        setContentForCell(cell, indexPath: indexPath)
        setTimeForCell(cell, indexPath: indexPath)
        setRepliesForCell(cell, indexPath: indexPath)
        setVoteNumberForCell(cell, indexPath: indexPath)
        return cell
    }
    func setContentForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let feed = feeds[row]
        cell.Content.text=feed.textView
        cell.feedId = feed.id
    }
    
    func setTimeForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let feed = feeds[row]
        
        let myString = feed.currentTime
        var myArray2 = myString.componentsSeparatedByString(".")
        cell.Time.text=myArray2[0]        
        //cell.MyTime.text = feed.currentTime
        
    }
    
    
    func setRepliesForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let feed = feeds[row]
        
        if(feed.feeds_commentSize > 1) {cell.Replies.text=String(feed.feeds_commentSize)+" replies"}
        else { cell.Replies.text=String(feed.feeds_commentSize)+" reply" }
        
    }
    
    
    func setVoteNumberForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let feed = feeds[row]
        
        cell.Number.text = String(feed.voteNum)
        
    }
    
    func setImageForCell(cell:ImageCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let feed = feeds[row]
        
        let imgURL: NSURL = NSURL(string: "http://45.33.44.105/jiaowen.com/image/"+feed.photoView.stringByReplacingOccurrencesOfString(" ", withString: "%20"))!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue(), completionHandler: { (request:NSURLResponse?,data:NSData?,error:NSError?) -> Void in
            
            if error==nil{
                cell.customImageView.image = UIImage(data:data!)
            }
        })
        
    }
    
    
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
       // print(feeds[row])
    }
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //    {
    //        return 300.0;//Choose your custom row height
    //    }
    
    
    func deselectAllRows() {
        if let selectedRows = homeTable.indexPathsForSelectedRows! as? [NSIndexPath] {
            for indexPath in selectedRows {
                homeTable.deselectRowAtIndexPath(indexPath, animated: false)
            }
        }
    }
    
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //    {
    //        return 400.0;//Choose your custom row height
    //    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isLandscapeOrientation() {
            return hasImageAtIndexPath(indexPath) ? 140.0 : 120.0
        } else {
            return hasImageAtIndexPath(indexPath) ? 235.0 : 155.0
        }
    }
    
    func isLandscapeOrientation() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == blogSegueIdentifier {
            if let destination = segue.destinationViewController as? BasicCellDetail {
                //print(homeTable.indexPathForSelectedRow)
                if let blogIndex = homeTable.indexPathForSelectedRow?.row {
                    destination.content = self.feeds[blogIndex]
                }
            }
        }
        if segue.identifier == blogSegueIdentifier2 {
            if let destination = segue.destinationViewController as? ImageCellDetail {
                //print(homeTable.indexPathForSelectedRow)
                if let blogIndex = homeTable.indexPathForSelectedRow?.row {
                    destination.content = self.feeds[blogIndex]
                }
            }
        }
    }

    
    
    
    @IBAction func unwindToHomeViewController(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.sourceViewController as? FeedViewController, feed = sourceViewController.feed
        {
            let newIndexPath = NSIndexPath(forRow: feeds.count, inSection: 0)
            feeds.append(feed)
            homeTable.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
    }
    
    
    
    
    
}

