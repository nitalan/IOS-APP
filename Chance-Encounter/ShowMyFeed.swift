//
//  ShowMyFeed.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/22/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//

import UIKit
import Foundation

class ShowMyFeed: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var MyTableView: UITableView!
    
    let basicCellIdentifier = "MyBasicCell"
    let imageCellIdentifier = "MyImageCell"
    
    let blogSegueIdentifier = "ShowMyBasicCell"
    let blogSegueIdentifier2 = "ShowMyImageCell"


    var feeds = [Feed]()
    
    func modifyUrl(str:String)->String{
        return str.stringByReplacingOccurrencesOfString(" ", withString: "%")
    }
    
    
    func loadSampleFeeds() {
        
        feeds = [Feed]()
        let myUrl = NSURL(string:"http://45.33.44.105/jiaowen.com/ShowMyFeeds.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod="POST";
        
        //compose a query string
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let postString = "username=\(prefs.valueForKey("USERNAME") as! String)";
        
        //var feed7 = Feed( textView: " ", currentTime: " " )
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                
                data,response,error in
                
                if error != nil
                {
                    //print("error=\(error)")
                    return
                }
                
                // You can print out response object
                
                //print("response = \(response)")
                
                // Print out response body
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //print("responseString = \(responseString)")
                
                //var err: NSError?
                
                let json = try!NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSArray
                
                if let parseJSON = json
                {
                    // Now we can access value of status by its key
                    //let resultValue = parseJSON["status"] as? String
                    for items in parseJSON
                    {
                        let id = items.objectAtIndex(0) as! String
                        let username = items.objectAtIndex(1) as! String
                        let des = items.objectAtIndex(2)as! String
                        let time = items.objectAtIndex(3) as! String
                        let commentSize = items.objectAtIndex(4) as! String
                        let voteNum = items.objectAtIndex(5) as! String
                        let imageView = items.objectAtIndex(6) as? String
                        
                        let feedx = Feed(id: Int(id)!, username: username,textView: des,currentTime: time,feeds_commentSize: Int(commentSize)!,voteNum:Int(voteNum)!,photoView:imageView!)!
                        self.feeds.append(feedx)
                        
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                        // 回调或者说是通知主线程刷新，text
                        // sleep(5)
                        self.MyTableView.reloadData()
                    });
                }
                
        }
        
        task.resume()
        
    }
    
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if hasImageAtIndexPath(indexPath) {
            
           
            return imageCellAtIndexPath(indexPath)
            
        } else {
           

            return basicCellAtIndexPath(indexPath)
        }
    }
    
    func hasImageAtIndexPath(indexPath:NSIndexPath) -> Bool {
        let feed = feeds[indexPath.row]
        if(feed.photoView.isEmpty){
            return false
        }
        return true
    }
    
    func basicCellAtIndexPath(indexPath:NSIndexPath) -> MyPostBasicCell {
        let cell = self.MyTableView.dequeueReusableCellWithIdentifier(basicCellIdentifier) as! MyPostBasicCell
        setContentForCell(cell, indexPath: indexPath)
        setTimeForCell(cell, indexPath: indexPath)
        setRepliesForCell(cell, indexPath: indexPath)
        setVoteNumberForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func imageCellAtIndexPath(indexPath:NSIndexPath) -> MyPostImageCell {
        let cell = self.MyTableView.dequeueReusableCellWithIdentifier(imageCellIdentifier) as! MyPostImageCell
        setImageForCell(cell, indexPath: indexPath)
        setContentForCell(cell, indexPath: indexPath)
        setTimeForCell(cell, indexPath: indexPath)
        setRepliesForCell(cell, indexPath: indexPath)
        setVoteNumberForCell(cell, indexPath: indexPath)
        return cell
    }
    func setContentForCell(cell:MyPostBasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let feed = feeds[row]
        cell.MyContent.text=feed.textView
    }
    
    func setTimeForCell(cell:MyPostBasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let feed = feeds[row]
        
        let myString = feed.currentTime
        var myArray2 = myString.componentsSeparatedByString(".")
        cell.MyTime.text=myArray2[0]        
          //cell.MyTime.text = feed.currentTime
       
    }
    
    
    func setRepliesForCell(cell:MyPostBasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let feed = feeds[row]
        
        if(feed.feeds_commentSize > 1) {cell.MyReplies.text=String(feed.feeds_commentSize)+" replies"}
        else { cell.MyReplies.text=String(feed.feeds_commentSize)+" reply" }
        
    }
    
    
    func setVoteNumberForCell(cell:MyPostBasicCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let feed = feeds[row]
        
        cell.MyNumber.text = String(feed.voteNum)
        
    }
    
    func setImageForCell(cell:MyPostImageCell, indexPath:NSIndexPath) {
        let row = indexPath.row
        let feed = feeds[row]
        
        let imgURL: NSURL = NSURL(string: "http://45.33.44.105/jiaowen.com/image/"+feed.photoView.stringByReplacingOccurrencesOfString(" ", withString: "%20"))!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(request, queue:NSOperationQueue.mainQueue(), completionHandler: { (request:NSURLResponse?,data:NSData?,error:NSError?) -> Void in
            
            if error==nil{
                cell.MyCustomImageView.image = UIImage(data:data!)
            }
        })
        
    }
    


    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //let row = indexPath.row
        //print(feeds[row])
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        return 300.0;//Choose your custom row height
//    }
    
    
    func deselectAllRows() {
        if let selectedRows = MyTableView.indexPathsForSelectedRows! as? [NSIndexPath] {
            for indexPath in selectedRows {
                MyTableView.deselectRowAtIndexPath(indexPath, animated: false)
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MyTableView.delegate = self
        MyTableView.dataSource = self
       
        
//         MyTableView.estimatedRowHeight = 89
//         MyTableView.rowHeight = UITableViewAutomaticDimension
        self.MyTableView.rowHeight = 170;
        //self.automaticallyAdjustsScrollViewInsets = false


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
      
            loadSampleFeeds()
          // deselectAllRows()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.MyTableView.reloadData()
            self.MyTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        })
        
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == blogSegueIdentifier {
            if let destination = segue.destinationViewController as? MyBasicDetail {
                //print(MyTableView.indexPathForSelectedRow)
                if let blogIndex = MyTableView.indexPathForSelectedRow?.row {
                    destination.content = self.feeds[blogIndex]
                }
            }
        }
        if segue.identifier == blogSegueIdentifier2 {
            if let destination = segue.destinationViewController as? MyImageDetail {
                //print(MyTableView.indexPathForSelectedRow)
                if let blogIndex = MyTableView.indexPathForSelectedRow?.row {
                    destination.content = self.feeds[blogIndex]
                }
            }
        }
    }
    

    
    
}