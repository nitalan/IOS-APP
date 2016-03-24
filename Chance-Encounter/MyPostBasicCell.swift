//
//  MyPostBasicCell.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/23/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//

import Foundation
import UIKit

class MyPostBasicCell: UITableViewCell {
    
    var feedId=0;
   
    @IBOutlet weak var MyContent: UILabel!
    
    @IBOutlet weak var MyTime: UILabel!
    
    
    @IBOutlet weak var MyReplies: UILabel!
    
    
    @IBOutlet weak var MyNumber: UILabel!
    
    
    @IBOutlet weak var MyUp: UIButton!
    
    
    @IBOutlet weak var MyDown: UIButton!
    
    @IBOutlet weak var CustomViewBasic: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        MyContent.sizeToFit()
    }
    
    
    @IBAction func upVote(sender: AnyObject) {
        if MyNumber.tag==0 {
            MyUp.setImage(UIImage(named:"upDark"), forState: .Selected)
            MyUp.setImage(UIImage(named:"upDark"), forState: .Highlighted)
            MyUp.setImage(UIImage(named:"upDark"), forState: .Normal)
            MyNumber.tag=1;
            MyNumber.text = String(Int( MyNumber.text!)! + 1)
            changeVoteNum(0,value2: 1);
            
        }
        else if MyNumber.tag==1{
           MyUp.setImage(UIImage(named:"up"), forState: .Normal)
           MyUp.setImage(UIImage(named:"up"), forState: .Selected)
           MyUp.setImage(UIImage(named:"up"), forState: .Highlighted)
            
            MyNumber.tag=0;
            MyNumber.text = String(Int(MyNumber.text!)! - 1)
            changeVoteNum(1,value2: 0);
        }
        else if MyNumber.tag == -1{
            MyDown.setImage(UIImage(named:"down"), forState: .Normal)
            MyDown.setImage(UIImage(named:"down"), forState: .Selected)
            MyDown.setImage(UIImage(named:"down"), forState: .Highlighted)
            
             MyUp.setImage(UIImage(named:"upDark"), forState: .Normal)
             MyUp.setImage(UIImage(named:"upDark"), forState: .Selected)
             MyUp.setImage(UIImage(named:"upDark"), forState: .Highlighted)
            
            MyNumber.tag=1;
            MyNumber.text = String(Int(MyNumber.text!)! + 2)
            changeVoteNum(-1,value2: 1);
            
        }

        
    }
    
    @IBAction func downVote(sender: AnyObject) {
        if MyNumber.tag==0 {
            MyDown.setImage(UIImage(named:"downDark"), forState: .Normal)
            MyDown.setImage(UIImage(named:"downDark"), forState: .Selected)
            MyDown.setImage(UIImage(named:"downDark"), forState: .Highlighted)
            
            MyNumber.tag = -1;
            MyNumber.text = String(Int(MyNumber.text!)! - 1)
            changeVoteNum(0,value2: -1);
        }
        else if MyNumber.tag == -1{
            MyDown.setImage(UIImage(named:"down"), forState: .Normal)
            MyDown.setImage(UIImage(named:"down"), forState: .Selected)
            MyDown.setImage(UIImage(named:"down"), forState: .Highlighted)
            MyNumber.tag = 0;
            MyNumber.text = String(Int(MyNumber.text!)! + 1)
            changeVoteNum(-1,value2: 0);
        }
        else if MyNumber.tag == 1{
            MyUp.setImage(UIImage(named:"up"), forState: .Normal)
            MyUp.setImage(UIImage(named:"up"), forState: .Selected)
            MyUp.setImage(UIImage(named:"up"), forState: .Highlighted)
            
            MyDown.setImage(UIImage(named:"downDark"), forState: .Normal)
            MyDown.setImage(UIImage(named:"downDark"), forState: .Selected)
            MyDown.setImage(UIImage(named:"downDark"), forState: .Highlighted)
            MyNumber.tag = -1;
            MyNumber.text = String(Int(MyNumber.text!)! - 2)
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
                
                print("response = \(response)")
                
                // Print out response body
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                
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
        
        
        CustomViewBasic.layer.masksToBounds = true
        CustomViewBasic.layer.cornerRadius = 10
       
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}