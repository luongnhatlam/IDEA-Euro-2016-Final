//
//  Team.swift
//  IDEA Euro 2016
//
//  Created by Cuu Long Hoang on 5/30/16.
//  Copyright © 2016 Long Hoang. All rights reserved.
//

import Foundation

struct Team {
    var name:String
    var point:Int = 0
    var rank:Int
    
    init?(data: [String:AnyObject]){
        guard let name = data["name"] as? String else { return nil }
        guard let rank = data["rank"] as? Int else { return nil }
        if let point = data["point"] as? Int {
            self.point = point
        }
        
        self.name = name
        self.rank = rank
    }
}