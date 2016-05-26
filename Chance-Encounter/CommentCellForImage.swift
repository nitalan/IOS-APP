//
//  CommentCellForImage.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 4/7/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//

import Foundation

import UIKit

class CommentCellForImage: UITableViewCell {
    
    
    
    @IBOutlet weak var CommentImage: UILabel!
    
    @IBOutlet weak var TimeImageCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
