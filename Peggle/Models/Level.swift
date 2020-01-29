//
//  Level.swift
//  Peggle
//
//  Created by Shawn Koh on 27/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

struct Level: Codable {
    // MARK: Properties
    var name: String
    var pegs: [Peg]
    /**
     Consider having these
     var author: String
     var createdAt: Date
     var updatedAt: Date
     var highScore: Int?
     */
}
