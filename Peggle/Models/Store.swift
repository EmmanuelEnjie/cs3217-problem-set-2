//
//  Store.swift
//  Peggle
//
//  Created by Shawn Koh on 3/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import RealmSwift

/// The `Store` represents `Peggle`'s persisted state.
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

    static func saveLevelData(_ levelData: LevelData) throws {
        try shared.write {
            shared.add(levelData)
        }
    }

    static func removeLevelData(_ levelData: LevelData) throws {
        try shared.write {
            shared.delete(levelData)
        }
    }

    /// Saves a new level.
    static func saveLevel(_ level: Level) throws -> LevelData {
        let levelData = LevelData()
        try shared.write {
            shared.add(levelData)
            levelData.name = level.name
            let pegDatas = level.pegs.map { PegData(peg: $0) }
            levelData.pegs.append(objectsIn: pegDatas)
        }
        return levelData
    }

    static func updateLevelData(_ levelData: LevelData, level: Level) throws -> LevelData {
        guard !levelData.isInvalidated else {
            return try saveLevel(level)
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
