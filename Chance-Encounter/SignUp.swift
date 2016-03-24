//
//  signUp.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/3/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//

import UIKit

class SignUp: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPwd: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var goBackLogin: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        confirmPwd.delegate = self
        username.layer.cornerRadius = 10;
        password.layer.cornerRadius = 10;
        confirmPwd.layer.cornerRadius = 10;
        
        
        //Making a padding object of view for first textField
        let paddingForFirst = UIView(frame: CGRectMake(0, 0, 15, self.username.frame.size.height))
        //Adding the padding to the second textField
        username.leftView = paddingForFirst
        username.leftViewMode = UITextFieldViewMode .Always
        
        //Making a padding object of view for second textField
        let paddingForSecond = UIView(frame: CGRectMake(0, 0, 15, self.password.frame.height))
        //Adding the padding to the second textField
        password.leftView = paddingForSecond
        password.leftViewMode = UITextFieldViewMode .Always
        
        let paddingForThird = UIView(frame: CGRectMake(0, 0, 15, self.confirmPwd.frame.height))
        //Adding the padding to the second textField
        confirmPwd.leftView = paddingForThird
        confirmPwd.leftViewMode = UITextFieldViewMode .Always

        
        
        signUpBtn.backgroundColor = UIColor(red: 168.0/255, green: 215.0/255, blue: 111.0/255, alpha: 1)
        signUpBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view, typically from a nib.
    }
    func textFieldShouldReturn(username:UITextField) -> Bool
    {
        //收起键盘
        username.resignFirstResponder()
//        password.resignFirstResponder()
//        confirmPwd.resignFirstResponder()
        //打印出文本框中的值
        print(username.text)
        return true;
    }
    
    func displayMyAlertMessage(userMessage:String)
    {
        let MyAlert = UIAlertController(title:"Alert",message:userMessage,preferredStyle:UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"Alert",style:UIAlertActionStyle.Default,handler:nil)
        
        MyAlert.addAction(okAction)
        self.presentViewController(MyAlert,animated:true,completion:nil);
    }
    

    
    @IBAction func singUpTapped(sender: AnyObject) {
        
        let usernameT = username.text!;
        let passwordT = password.text!;
        let  confirmPwdT = confirmPwd.text!;
       
        //check for empty fields.
        if(usernameT.isEmpty||passwordT.isEmpty||confirmPwdT.isEmpty)
        {
            //display alert message
            displayMyAlertMessage("All Files Are Required");
            //  dispatch_async("All Files Are Required");
            return;
        }
        
        if(passwordT != confirmPwdT)
        {
            displayMyAlertMessage("Password do not match");
            return;
        }
        let myUrl = NSURL(string:"http://45.33.44.105/jiaowen.com/SignUp.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod="POST";
        //compose a query string
        let postString = "username=\(usernameT)&password=\(passwordT)";
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        
        //
        //        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
        //            (response, data, error) in
        //            println(response)
        //
        //        })
        
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
                    
                    var isUserRegistered:Bool = false;
                    if(resultValue == "Success"){
                        isUserRegistered = true
                    }
                    
                    let messageToDisplay = parseJSON["message"] as! String!;
                    
                    if(!isUserRegistered)
                    {
                        _ = parseJSON["message"] as! String!;
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        // 回调或者说是通知主线程刷新，
                        
                        let MyAlert =
                        UIAlertController(title:"Alert",
                            message:messageToDisplay,
                            preferredStyle:UIAlertControllerStyle.Alert);
                        
                        let okAction = UIAlertAction(title:"OK",
                            style:UIAlertActionStyle.Default){
                                action in
                                self.dismissViewControllerAnimated(true, completion: nil);
                        }
                        
                        MyAlert.addAction(okAction);
                        self.presentViewController(MyAlert,animated:true,
                            completion:nil);
                        
                    });
                    
                }
                
        }
        task.resume()
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
