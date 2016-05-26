//
//  CommentTableViewCell.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 4/1/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//


import Foundation
import UIKit

class CommentTableViewCell: UITableViewCell {
    


    @IBOutlet weak var CommentText: UILabel!
    
    @IBOutlet weak var Time: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
