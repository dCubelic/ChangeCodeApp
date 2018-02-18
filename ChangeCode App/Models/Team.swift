//
//  Team.swift
//  HTTPTest
//
//  Created by dominik on 18/02/2018.
//  Copyright © 2018 Dominik Cubelic. All rights reserved.
//

import Foundation

class Team {
    var name: String
    var id: Int
    var members: [TeamMember] = []
    
    init(json: [String: Any?]) {
        self.id = json["Id"] as! Int
        self.name = json["TeamName"] as! String
        let membersJson = json["Members"] as! [[String: Any]]
        
        for member in membersJson {
            members.append(TeamMember(json: member))
        }
    }
}
