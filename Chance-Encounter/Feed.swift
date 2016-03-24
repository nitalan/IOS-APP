//
//  Feed.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/22/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//

import Foundation
import UIKit

class Feed {
    // MARK: Properties
    
    var id:Int
    var username:String
    var textView: String
    var currentTime: String
    var feeds_commentSize: Int
    var voteNum:Int
    var photoView:String
    
    // MARK: Initialization
    
    init?(id:Int, username:String, textView: String, currentTime: String, feeds_commentSize:Int, voteNum: Int,photoView:String) {
        // Initialize stored properties.
        self.id = id
        self.username = username
        self.textView = textView
        self.currentTime = currentTime
        self.feeds_commentSize = feeds_commentSize
        self.voteNum=voteNum
        self.photoView = photoView
        
        
        // Initialization should fail if there is no name or if the rating is negative.
        if textView.isEmpty  {
            return nil
        }
    }
    
}
