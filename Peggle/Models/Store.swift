//
//  Store.swift
//  Peggle
//
//  Created by Shawn Koh on 3/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import RealmSwift

/// The `Store` represents the persisted state of Peggle.
struct Store {
    static let shared = Store().realm
    private var realm: Realm

    private init() {
        do {
            realm = try Realm()
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }

    static var levelDatas: Results<LevelData> {
        shared.objects(LevelData.self)
    }

    /// Saves a `LevelData` into the store.
    /// - Parameter _: The level data to be saved.
    @discardableResult
    static func saveLevelData(_ levelData: LevelData) throws -> LevelData {
        try shared.write {
            shared.add(levelData)
        }
        return levelData
    }

    /// Removes a `LevelData` from the store.
    /// - Parameter _: The level data to be removed.
    static func removeLevelData(_ levelData: LevelData) throws {
        try shared.write {
            shared.delete(levelData)
        }
    }

    static func updateLevelData(_ levelData: LevelData, level: Level) throws -> LevelData {
        guard !levelData.isInvalidated else {
            return try saveLevelData(levelData)
        }

        try shared.write {
            levelData.name = level.name
            levelData.pegs.removeAll()
            let pegDatas = level.pegs.map { PegData(peg: $0) }
            levelData.pegs.append(objectsIn: pegDatas)
        }
        return levelData
    }
}
