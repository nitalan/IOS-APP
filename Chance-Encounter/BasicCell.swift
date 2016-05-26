//
//  BasicCell.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/21/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//

import Foundation
import UIKit

class BasicCell: UITableViewCell {
   
    var feedId=0 
    
    @IBOutlet weak var Content: UILabel!
    
    @IBOutlet weak var Time: UILabel!
    
    @IBOutlet weak var Replies: UILabel!
    
    @IBOutlet weak var Number: UILabel!
    
    @IBOutlet weak var Up: UIButton!
    
    @IBOutlet weak var Down: UIButton!
    
    @IBOutlet weak var HomeView: UIView!
    override func layoutSubviews() {
        super.layoutSubviews()
        Content.sizeToFit()
    }
    
    
    
    
    
    @IBAction func upVote(sender: AnyObject) {
        if Number.tag==0 {
            Up.setImage(UIImage(named:"upDark"), forState: .Selected)
            Up.setImage(UIImage(named:"upDark"), forState: .Highlighted)
            Up.setImage(UIImage(named:"upDark"), forState: .Normal)
            Number.tag=1;
            Number.text = String(Int( Number.text!)! + 1)
            changeVoteNum(0,value2: 1);
            
        }
        else if Number.tag==1{
            Up.setImage(UIImage(named:"up"), forState: .Normal)
            Up.setImage(UIImage(named:"up"), forState: .Selected)
            Up.setImage(UIImage(named:"up"), forState: .Highlighted)
            
            Number.tag=0;
            Number.text = String(Int(Number.text!)! - 1)
            changeVoteNum(1,value2: 0);
        }
        else if Number.tag == -1{
            Down.setImage(UIImage(named:"down"), forState: .Normal)
            Down.setImage(UIImage(named:"down"), forState: .Selected)
            Down.setImage(UIImage(named:"down"), forState: .Highlighted)
            
            Up.setImage(UIImage(named:"upDark"), forState: .Normal)
            Up.setImage(UIImage(named:"upDark"), forState: .Selected)
            Up.setImage(UIImage(named:"upDark"), forState: .Highlighted)
            
            Number.tag=1;
            Number.text = String(Int(Number.text!)! + 2)
            changeVoteNum(-1,value2: 1);
            
        }
        
        
    }
    
    @IBAction func downVote(sender: AnyObject) {
        if Number.tag==0 {
            Down.setImage(UIImage(named:"downDark"), forState: .Normal)
            Down.setImage(UIImage(named:"downDark"), forState: .Selected)
            Down.setImage(UIImage(named:"downDark"), forState: .Highlighted)
            
            Number.tag = -1;
            Number.text = String(Int(Number.text!)! - 1)
            changeVoteNum(0,value2: -1);
        }
        else if Number.tag == -1{
            Down.setImage(UIImage(named:"down"), forState: .Normal)
            Down.setImage(UIImage(named:"down"), forState: .Selected)
            Down.setImage(UIImage(named:"down"), forState: .Highlighted)
            Number.tag = 0;
            Number.text = String(Int(Number.text!)! + 1)
            changeVoteNum(-1,value2: 0);
        }
        else if Number.tag == 1{
            Up.setImage(UIImage(named:"up"), forState: .Normal)
            Up.setImage(UIImage(named:"up"), forState: .Selected)
            Up.setImage(UIImage(named:"up"), forState: .Highlighted)
            
            Down.setImage(UIImage(named:"downDark"), forState: .Normal)
            Down.setImage(UIImage(named:"downDark"), forState: .Selected)
            Down.setImage(UIImage(named:"downDark"), forState: .Highlighted)
            Number.tag = -1;
            Number.text = String(Int(Number.text!)! - 2)
            changeVoteNum(1,value2: -1);
        }
        
        
    }
    
    func changeVoteNum(value1:Int, value2: Int){
        let myUrl = NSURL(string:"http://45.33.44.105/jiaowen.com/changeVote.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod="POST";
        
        //compose a query string
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let postString = "username=\(prefs.valueForKey("USERNAME") as! String)&feed_id=\(feedId)&value=\(value1)&value2=\(value2)";
        
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
           // print("responseString = \(responseString)")
            
            //var err: NSError?
            
            let json = try!NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
            
            if let parseJSON = json
            {
                // Now we can access value of status by its key
                //let resultValue = parseJSON["status"] as? String
                let result = parseJSON["status"] as? String
                if result == "success" {
                    dispatch_async(dispatch_get_main_queue(),{
                        // 回调或者说是通知主线程刷新，text
                        // sleep(5)
                        //self.reloadData()
                    });
                }
            }
            
        }
        
        task.resume()
    }

    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        HomeView.layer.masksToBounds = true
//        HomeView.layer.cornerRadius = 10
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}