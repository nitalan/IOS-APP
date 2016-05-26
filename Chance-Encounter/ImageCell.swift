//
//  ImageCell.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/21/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//
import Foundation
import UIKit

class ImageCell: BasicCell {
    
    @IBOutlet weak var customImageView: UIImageView!
    
    var imageWidth:Int!
    var imageHeight:Int!
    var oldFrame:CGRect!;
    required init(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)!
    }
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //customImageView.zPosition = 1;
       customImageView.layer.zPosition = 100
        
        customImageView.userInteractionEnabled = true
        self.oldFrame = customImageView.frame
        let show = UITapGestureRecognizer(target: self, action: #selector(MyPostImageCell.showImage(_:)))
        customImageView.addGestureRecognizer(show)
        
    }
    
    
    
    
    func showImage(sender: UITapGestureRecognizer){
        let image = customImageView.image
        let window = UIApplication.sharedApplication().keyWindow
        let backgroundView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        backgroundView.backgroundColor = UIColor.blackColor()
        backgroundView.alpha = 0
        let imageView = UIImageView(frame: customImageView.frame)
        
        imageView.image = image
        imageView.tag = 1
        backgroundView.addSubview(imageView)
        window?.addSubview(backgroundView)
        let hide = UITapGestureRecognizer(target: self, action: #selector(ImageCell.hideImage(_:)))
        
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
    
    
    

    
    
    
    
    
    
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    


}