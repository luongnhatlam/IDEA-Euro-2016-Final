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
    
    init?(data: [String:AnyObject]){
        guard let name = data["name"] as? String else { return nil }
        if let point = data["point"] as? Int {
            self.point = point
        }
        
        self.name = name
    }
    
    init(name:String, point:Int) {
        self.name   = name
        self.point  = point
    }
    
    init(name:String) {
        self.init(name: name, point: 0)
    }
}