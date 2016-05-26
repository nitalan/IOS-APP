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