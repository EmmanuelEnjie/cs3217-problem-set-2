//
//  LevelData.swift
//  Peggle
//
//  Created by Shawn Koh on 2/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import RealmSwift

class LevelData: Object {
    override class func primaryKey() -> String? {
        "id"
    }

    // Realm has no auto-incrementing properties, so generate a unique string ID.
    // More info here: https://realm.io/docs/swift/latest#limitations-models
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var name = Settings.defaultLevelName
    let pegs = List<PegData>()
}
