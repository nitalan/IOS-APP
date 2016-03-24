//
//  BasicCell.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/21/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//

import Foundation
import UIKit

class BasicCell: UITableViewCell {
    
    
    @IBOutlet weak var Content: UILabel!
    
    @IBOutlet weak var Time: UILabel!
    
    @IBOutlet weak var Replies: UILabel!
    
    @IBOutlet weak var Number: UILabel!
    
    @IBOutlet weak var Up: UIButton!
    
    @IBOutlet weak var Down: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Content.sizeToFit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}