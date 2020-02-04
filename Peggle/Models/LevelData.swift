//
//  LevelData.swift
//  Peggle
//
//  Created by Shawn Koh on 2/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import RealmSwift

/**
 `LevelData` represents a data model object for the abstract data structure `Level`.
 It is intended to be used for persisting `Level`s.
*/
class LevelData: Object {
    override class func primaryKey() -> String? {
        "id"
    }

    // Realm has no auto-incrementing properties, so generate a unique string ID.
    // More info here: https://realm.io/docs/swift/latest#limitations-models
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var name = Settings.defaultLevelName
    let pegs: List<PegData>

    /// Constructs an empty `LevelData`.
    required init() {
        self.pegs = List()
        super.init()
    }

    /// Constructs a new `LevelData`.
    /// - Parameters:
    ///     - name: The name of the level.
    ///     - pegs: A list of the level's pegs.
    init(name: String, pegs: List<PegData>) {
        self.name = name
        self.pegs = pegs
    }

    /// Constructs a new `LevelData`.
    /// - Parameter level: A `Level` abstract data structure.
    convenience init(level: Level) {
        let pegDatas = level.pegs.map { PegData(peg: $0) }
        let pegs = List<PegData>()
        pegs.append(objectsIn: pegDatas)
        self.init(name: level.name, pegs: pegs)
    }
}
