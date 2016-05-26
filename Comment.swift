//
//  Comment.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 4/1/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//


import Foundation
import UIKit

class Comment{
    // MARK: Properties
    
    //var id:Int
    var comment_feed:Int
    var comment_content: String
    var comment_time: String
    var comment_vote:Int
    var comment_person:String
    
    
    // MARK: Initialization
    
    init?(comment_feed:Int, comment_content:String, comment_time: String, comment_vote: Int, comment_person:String ) {
        // Initialize stored properties.
        //self.id = id
        self.comment_feed = comment_feed
        self.comment_content = comment_content
        self.comment_time = comment_time
        self.comment_vote = comment_vote
        self.comment_person = comment_person
        
        
        // Initialization should fail if there is no name or if the rating is negative.
        if comment_content.isEmpty  {
            return nil
        }
    }
    
}