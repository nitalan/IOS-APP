//
//  BasicCellDetail.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/21/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//

import Foundation
import UIKit

class MyBasicDetail: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var content:Feed!
    
    var comments = [Comment]()
    
    
    let commentCellIdentifier = "MyCommentCell"
    
    @IBOutlet weak var PostContent: UILabel!
    
    @IBOutlet weak var UpVote: UIButton!
    
    @IBOutlet weak var DownVote: UIButton!
    @IBOutlet weak var Number: UILabel!
    
    @IBOutlet weak var Replies: UILabel!
    
    @IBOutlet weak var CommentTable: UITableView!
    
    @IBOutlet weak var Time: UILabel!
    
    
    @IBOutlet weak var ContentBottom: UIView!
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier, forIndexPath: indexPath) as! MyBasicCell
        
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        cell.separatorInset = UIEdgeInsetsZero
        
        let row = indexPath.row
        let comment = comments[row]
        
        cell.MyCommentText.text = comment.comment_content
        
        let myString = comment.comment_time
        var myArray2 = myString.componentsSeparatedByString(".")
        cell.MyTime.text = myArray2[0]
        //cell.timeLabel.text = comment.comment_time
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    func loadComment() {
        
        
        let myUrl = NSURL(string:"http://45.33.44.105/jiaowen.com/ShowComment.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod="POST";
        
        //compose a query string
        let postString = "feed_id=\(content.id)";
        
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
            
           // print("response = \(response)")
            
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
                    let comment_feed = items.objectAtIndex(1) as! String
                    let comment_content = items.objectAtIndex(2) as! String
                    let comment_time = items.objectAtIndex(3) as! String
                    let comment_vote = items.objectAtIndex(4) as! String
                    let comment_person = items.objectAtIndex(5) as! String
                    let commentx = Comment(comment_feed: Int(comment_feed)!, comment_content: comment_content,comment_time: comment_time,comment_vote: Int(comment_vote)!,comment_person: comment_person)!
                    self.comments.append(commentx)
                    
                }
                dispatch_async(dispatch_get_main_queue(),{
                    // 回调或者说是通知主线程刷新，text
                    // sleep(5)
                    self.CommentTable.reloadData()
                });
            }
            
        }
        
        task.resume()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        loadComment()
       // print (content);
        
        PostContent.text = content.textView
        
        let myString = content.currentTime
        var myArray2 = myString.componentsSeparatedByString(".")
        Time.text = myArray2[0]
        
        if(content.feeds_commentSize > 1) { Replies.text = String(content.feeds_commentSize)+" replies"}
        else { Replies.text = String(content.feeds_commentSize)+" reply" }
        
        //voteNum?.text = String (feed.voteNum)
        Number.text = String(content.voteNum)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CommentTable.delegate = self
        CommentTable.dataSource = self
        
        PostContent.sizeToFit()
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}