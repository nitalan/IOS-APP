//
//  login.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/3/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//


import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var login: UIButton!
   
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
 
    @IBOutlet weak var GoToSignUp: UIButton!
    
    
    override func viewDidLoad() {
        
        //self.activityIndicatorView.layer.cornerRadius = 10

        super.viewDidLoad()
        usernameText.delegate = self
        passwordText.delegate = self
    
       
        usernameText.textAlignment = .Center //水平居中对齐
        usernameText.layer.cornerRadius = 20.0
        usernameText.alpha = 0.5
        usernameText.layer.borderColor = UIColor.whiteColor().CGColor
        usernameText.layer.borderWidth = 1.0
        
        
        passwordText.textAlignment = .Center //水平居中对齐
        passwordText.layer.cornerRadius = 20.0
        passwordText.alpha = 0.5
        passwordText.layer.borderColor = UIColor.whiteColor().CGColor
        passwordText.layer.borderWidth = 1.0
        
        login.backgroundColor = UIColor(red: 168.0/255, green: 215.0/255, blue: 111.0/255, alpha: 1)
        login.layer.cornerRadius = 20
       
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    
    func textFieldShouldReturn(username:UITextField) -> Bool
    {
        //收起键盘
        username.resignFirstResponder()
        //打印出文本框中的值
        return true;
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displayMyAlertMessage(userMessage:String)
    {
        let MyAlert = UIAlertController(title:"Alert",message:userMessage,preferredStyle:UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.Default,handler:nil)
        
        MyAlert.addAction(okAction)
        self.presentViewController(MyAlert,animated:true,completion:nil);
    }
    
    
    
    @IBAction func signIn(sender: AnyObject) {
        var username = usernameText.text!;
        let password = passwordText.text!;
        while(username[username.endIndex.advancedBy(-1)]==" "){
            username.removeAtIndex(username.endIndex.advancedBy(-1))
        }
        
            
            let myUrl = NSURL(string:"http://45.33.44.105/jiaowen.com/UserLogin.php");
            
            let request = NSMutableURLRequest(URL:myUrl!);
            request.HTTPMethod="POST";
            
            //compose a query string
            let pwdt = password.sha1()
            let postString:String! = "username=\(username)&password=\(pwdt)";
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {
                
                data,response,error in
                
                
                if error != nil
                {
                    //print("error=\(error)")
                    return
                    
                }
                //print("response = \(response)")
                // Print out response body
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                //print("responseString = \(responseString)")
                
                
                
                // var err: NSError?
                
                let json = try!NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                if let parseJSON = json
                {
                    let resultValue = parseJSON["status"] as? String
                    //print("result: \(resultValue)")
                    
                    //                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn");
                    //                        var isUserloged:Bool = false;
                    
                    
                    func displayMyAlertMessage(userMessage:String)
                    {
                        let MyAlert = UIAlertController(title:"Alert",message:userMessage,preferredStyle:UIAlertControllerStyle.Alert);
                        
                        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.Default,handler:nil)
                        
                        MyAlert.addAction(okAction)
                        self.presentViewController(MyAlert,animated:true,completion:nil);
                    }
                    if(resultValue=="Success")
                    {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock{
                            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setObject(username.sha1(), forKey: "USERNAME")
                            //username.sha1()
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLogged")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            
                            self.performSegueWithIdentifier("goToHome", sender: self)
                            
                        }
                        
                    }
                    else if(resultValue=="Error" || username.isEmpty || password.isEmpty){
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            displayMyAlertMessage("Invalid username or password")
                        }
                        
                        
                    }
                    
                    
                    
                    //print(json)
                }
                
            }
            task.resume()

            
        }
        
    

        
    
    
    
    
    
}
