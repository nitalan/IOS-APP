//
//  MyBasicCell.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 4/14/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//

import Foundation
import UIKit

class MyBasicCell: UITableViewCell {
    
    
    
    @IBOutlet weak var MyCommentText: UILabel!
    
    @IBOutlet weak var MyTime: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

