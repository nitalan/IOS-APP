//
//  FeedViewController.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/21/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//

import Foundation
import UIKit

class FeedViewController: UIViewController,UITextViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate {
    
    @IBOutlet weak var NewFeed: UITextView!
    
    @IBOutlet weak var LimitNumber: UILabel!
    
    @IBOutlet weak var NewImage: UIImageView!
    
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    
    @IBOutlet weak var ImageButton: UIButton!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
      var feed:Feed?

    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker .dismissViewControllerAnimated(true, completion: nil)
        NewImage.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    
    
    func imagePickerControllerDidCancel()
    {
        print("picker cancel.")
    }

    @IBAction func ChooseImage(sender: AnyObject) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
                
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in self.imagePickerControllerDidCancel()
                
        }
        
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(ImageButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        

        
           }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(ImageButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String, imageName: String) -> NSData {
        
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendData(NSString(format:"--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
                body.appendData(NSString(format:"Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
                body.appendData(NSString(format:"\(value)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        
        let filename = imageName
        
        // let mimetype = "application/octet-stream";
        let mimetype = "image/jpg"
        body.appendData(NSString(format:"--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Type: \(mimetype)\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(imageDataKey)
        body.appendData(NSString(format:"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData(NSString(format:"--\(boundary)--\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        if SaveButton === sender {
            let description = NewFeed.text!
            let image = NewImage.image
            if(description.isEmpty){
               // displayMyAlertMessage("Please input content!");
                //return;
            }
            let date = NSDate()
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss.SSS"
            let commentTime = timeFormatter.stringFromDate(date) as String
            //feed = Feed(textView:description,currentTime:commentTime);
            //feed = Feed(id: id, username: username,textView: des,currentTime: time,feeds_commentSize: commentSize)
            
            let myUrl = NSURL(string:"http://45.33.44.105/jiaowen.com/AddFeeds.php");
            let request = NSMutableURLRequest(URL:myUrl!);
            request.HTTPMethod="POST";
            //compose a query string
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let username:String = String(prefs.valueForKey("USERNAME") as! String )
            
            
            if(image==nil) {
                let imageName:String = "a"
                
                let postString = "username=\(username)&description=\(description)&time=\(commentTime)&image=\(imageName)";
                request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
            }
            else{
                let boundary = generateBoundaryString()
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                let imageData = UIImageJPEGRepresentation(image!, 1)
                let imageName:String =  commentTime + String(arc4random_uniform(100))+".jpg"
                let param = [
                    "username"  : username,
                    "description"    : description,
                    "time"    : commentTime,
                    "imageName" : imageName
                ]
                request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary,imageName: imageName)
                
            }
            
            
            
            
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
                        
                        if(resultValue == "Success"){
                            let id = (parseJSON["detail"]!)[0] as! String
                            let username = (parseJSON["detail"]!)[1] as! String
                            let commentSize = (parseJSON["detail"]!)[4] as! String
                            let image = (parseJSON["detail"]!)[6] as! String
                            //                            let decodedData = NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                            //                            let decodedimage = UIImage(data: decodedData!)
                            //println(decodedimage)
                            //                            yourImageView.image = decodedimage as UIImage
                            self.feed = Feed(id: Int(id)!, username: username,textView: description,currentTime: commentTime,feeds_commentSize: Int(commentSize)!,voteNum:0,photoView:image)
                            dispatch_async(dispatch_get_main_queue(),{
                                // 回调或者说是通知主线程刷新，text
                                // sleep(5)
                                
                            });
                        }
                        
                        
                    }
                    
            }
            task.resume()
            
            
            
        }
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
         SaveButton.enabled = false
    }
    
    func checkValidText() {
        // Disable the Save button if the text field is empty.
        let text = NewFeed.text
        SaveButton.enabled = !text.isEmpty
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        checkValidText()
    }


    func displayMyAlertMessage(userMessage:String)
    {
        let MyAlert = UIAlertController(title:"Alert",message:userMessage,preferredStyle:UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.Default,handler:nil)
        
        MyAlert.addAction(okAction)
        self.presentViewController(MyAlert,animated:true,completion:nil);
    }


    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText string: String) -> Bool{
        let maxLength = 119
        let currentString: NSString = NewFeed.text
        let newString: NSString =
        currentString.stringByReplacingCharactersInRange(range, withString: string)
        LimitNumber.text = String(120-newString.length)
        return newString.length <= maxLength
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       NewFeed.delegate = self
        
       NewFeed.layer.borderColor = UIColor.blackColor().CGColor
       NewFeed.layer.borderWidth = 0.5
       NewFeed.layer.cornerRadius = 5
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
      self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        checkValidText()

    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
   
    
}
