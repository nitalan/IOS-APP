//
//  BasicCellDetail.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/21/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//

import Foundation
import UIKit

class BasicCellDetail: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    var content:Feed!
    var rstring:String = ""
    
    var comments = [Comment]()
    
    var keyboardPresent = false
    
    
     let commentCellIdentifier = "commentCell"
    
    @IBOutlet weak var PostContent: UILabel!
    
    @IBOutlet weak var UpVote: UIButton!
    
    @IBOutlet weak var DownVote: UIButton!
    @IBOutlet weak var Number: UILabel!
    
    @IBOutlet weak var Replies: UILabel!
    
    @IBOutlet weak var PostImage: UIImageView!
    @IBOutlet weak var CommentTable: UITableView!
    
    @IBOutlet weak var Time: UILabel!
    
    
    @IBOutlet weak var CommentReply: UITextField!
   
   
    
    @IBOutlet weak var SendButton: UIButton!
    

    @IBOutlet weak var ReplyBottom: UIView!

   
    @IBOutlet weak var ContentBottom: UIView!

    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier, forIndexPath: indexPath) as! CommentTableViewCell
        
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        cell.separatorInset = UIEdgeInsetsZero
        
        let row = indexPath.row
        let comment = comments[row]
        
        cell.CommentText.text = comment.comment_content
        
        let myString = comment.comment_time
        var myArray2 = myString.componentsSeparatedByString(".")
        cell.Time.text = myArray2[0]
        //cell.timeLabel.text = comment.comment_time
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func displayMyAlertMessage(userMessage:String)
    {
        let MyAlert = UIAlertController(title:"Alert",message:userMessage,preferredStyle:UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.Default,handler:nil)
        
        MyAlert.addAction(okAction)
        self.presentViewController(MyAlert,animated:true,completion:nil);
    }
    
    
    
    @IBAction func SendBtnTag(sender: AnyObject) {
        
        
        let description = CommentReply.text!
        if(description.isEmpty){
            displayMyAlertMessage("Comments cannot be empty!");
            return;
        }
       
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss.SSS"
        let commentTime = timeFormatter.stringFromDate(date) as String
        //feed = Feed(textView:description,currentTime:commentTime);
        //feed = Feed(id: id, username: username,textView: des,currentTime: time,feeds_commentSize: commentSize)
        
        let myUrl = NSURL(string:"http://45.33.44.105/jiaowen.com/AddComments.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod="POST";
        //compose a query string
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        //print(prefs.valueForKey("USERNAME") as? String)
        
        let postString = "username=\(prefs.valueForKey("USERNAME") as! String)&feed_id=\(content.id)& comment_content=\(description)&comment_time=\(commentTime)";
        
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
            print("response = \(response)")
            // Print out response body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            //var err: NSError?
            
            let json = try!NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
            
            if let parseJSON = json
                
            {
                // Now we can access value of status by its key
                let resultValue = parseJSON["status"] as? String
                print("result: \(resultValue)")
                
                if(resultValue == "success"){
                    
                    let commentx2 = Comment(comment_feed: self.content.id, comment_content: description,comment_time: commentTime,comment_vote: 0,comment_person: (prefs.valueForKey("USERNAME") as! String))!
                    self.comments.append(commentx2);
                    self.content.feeds_commentSize=self.content.feeds_commentSize+1;
                    dispatch_async(dispatch_get_main_queue(),{
                        // 回调或者说是通知主线程刷新，text
                        // sleep(5)
                        if(self.content.feeds_commentSize > 1){
                            self.rstring = "replies"
                        }else{
                            self.rstring = "reply"
                        }
                        self.Replies.text = String(self.content.feeds_commentSize) + " " + self.rstring
                        self.CommentReply.text = ""
                        self.CommentTable.reloadData()
                    });
                    
                }
            }
            
        }
        task.resume()
         CommentReply.resignFirstResponder()
    
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
            
            print("response = \(response)")
            
            // Print out response body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
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
        print (content);
        
        PostContent.text = content.textView
        
        let myString = content.currentTime
        var myArray2 = myString.componentsSeparatedByString(".")
        Time.text = myArray2[0]
        
        if(content.feeds_commentSize > 1) { Replies.text = String(content.feeds_commentSize)+" replies"}
        else { Replies.text = String(content.feeds_commentSize)+" reply" }
        
        //voteNum?.text = String (feed.voteNum)
        Number.text = String(content.voteNum)

    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if(!keyboardPresent){
                self.view.frame.origin.y =  self.view.frame.origin.y-keyboardSize.height + 25
                keyboardPresent = true
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if(keyboardPresent){
                self.view.frame.origin.y += keyboardSize.height - 25
                keyboardPresent = false
            }
        }
    }
    



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CommentTable.delegate = self
        CommentTable.dataSource = self
        CommentReply.delegate=self
        
        PostContent.sizeToFit()

        
       // SendButton.backgroundColor = UIColor(red: 168.0/255, green: 215.0/255, blue: 111.0/255, alpha: 1)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BasicCellDetail.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BasicCellDetail.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func textFieldShouldReturn(username:UITextField) -> Bool
    {
        //收起键盘
        CommentReply.resignFirstResponder()
        
        return true;
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}