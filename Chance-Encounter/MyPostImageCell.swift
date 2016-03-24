//
//  MyPostImageCell.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/23/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//
import Foundation
import UIKit

class MyPostImageCell: MyPostBasicCell {
    
   
    
    @IBAction override func upVote(sender: AnyObject) {
    }
    
    
    @IBAction override func downVote(sender: AnyObject) {
        
    }
    @IBOutlet weak var MyCustomImageView: UIImageView!
    
    var imageWidth:Int!
    var imageHeight:Int!
    var oldFrame:CGRect!;
    required init(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)!
        
        
    }
    

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        self.MyCustomImageView.frame = CGRect(x: 20, y: 200, width: 130, height: 100)
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        //设置头像是圆形显示
//        MyCustomImageView.layer.masksToBounds = true
//        MyCustomImageView.layer.cornerRadius = MyCustomImageView.frame.size.width/2
//        //设置cell是有圆角边框显示
//        CustomView.layer.masksToBounds = true
//        CustomView.layer.cornerRadius = 10
        
        
        MyCustomImageView.userInteractionEnabled = true
        self.oldFrame = MyCustomImageView.frame
        let show = UITapGestureRecognizer(target: self, action: "showImage:")
        MyCustomImageView.addGestureRecognizer(show)
        

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func showImage(sender: UITapGestureRecognizer){
        let image = MyCustomImageView.image
        let window = UIApplication.sharedApplication().keyWindow
        let backgroundView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        backgroundView.backgroundColor = UIColor.blackColor()
        backgroundView.alpha = 0
        let imageView = UIImageView(frame: MyCustomImageView.frame)
        
        imageView.image = image
        imageView.tag = 1
        backgroundView.addSubview(imageView)
        window?.addSubview(backgroundView)
        let hide = UITapGestureRecognizer(target: self, action: "hideImage:")
        
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(hide)
        UIView.animateWithDuration(0.3, animations:{ () in
            let vsize = UIScreen.mainScreen().bounds.size
            imageView.frame = CGRect(x:0.0, y: 0.0, width: vsize.width, height: vsize.height)
            imageView.contentMode = .ScaleAspectFit
            backgroundView.alpha = 1
            }, completion: {(finished:Bool) in })
        
    }
    
    func hideImage(sender: UITapGestureRecognizer){
        let backgroundView = sender.view as UIView?
        if let view = backgroundView{
            UIView.animateWithDuration(0.3,
                animations:{ () in
                    let imageView = view.viewWithTag(1) as! UIImageView
                    imageView.frame = self.oldFrame
                    imageView.alpha = 0
                    
                },
                completion: {(finished:Bool) in
                    view.alpha = 0
                    view.superview?.removeFromSuperview()
                    view.removeFromSuperview()
            })
        }
    }

    
    
}