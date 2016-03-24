//
//  Vote.swift
//  Chance-Encounter
//
//  Created by 皎文 蓝 on 3/24/16.
//  Copyright © 2016 jiaowen. All rights reserved.
//

import Foundation
import UIKit

class Vote{
    // MARK: Properties
    
    //var id:Int
    var vote_person:String
    var vote_feed: Int
    var value: Int
    
    
    // MARK: Initialization
    
    init?(vote_person:String, vote_feed: Int, value:Int ) {
        // Initialize stored properties.
        //self.id = id
        self.vote_person = vote_person
        self.vote_feed = vote_feed
        self.value = value
        
        // Initialization should fail if there is no name or if the rating is negative.
    }
    
}