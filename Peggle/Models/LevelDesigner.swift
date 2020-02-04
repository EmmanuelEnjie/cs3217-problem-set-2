//
//  LevelDesigner.swift
//  Peggle
//
//  Created by Shawn Koh on 4/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import CoreGraphics

/// The `LevelDesigner` represents the state of Peggle's level designer.
struct LevelDesigner {
    static var level: Level?
    static var levelData: LevelData?
    private init() {}

    static func saveLevelData() throws {
        guard let level = level else {
            return
        }

        if let levelData = self.levelData {
            self.levelData = try Store.updateLevelData(levelData, level: level)
        } else {
            let levelData = LevelData(level: level)
            self.levelData = try Store.saveLevelData(levelData)
        }
    }

    static func setup(levelDelegate: LevelDelegate) {
        if let levelData = LevelDesigner.levelData {
            LevelDesigner.loadLevelData(levelData, levelDelegate: levelDelegate)
        } else {
            LevelDesigner.loadEmptyLevel(levelDelegate: levelDelegate)
        }
    }

    static func loadEmptyLevel(levelDelegate: LevelDelegate?) {
        level = Level(name: Settings.defaultLevelName, pegs: Set(), delegate: levelDelegate)
        levelData = nil
    }

    static func loadLevelData(_ levelData: LevelData, levelDelegate: LevelDelegate?) {
        self.levelData = levelData
        self.level = constructLevel(from: levelData, delegate: levelDelegate)
    }

    @discardableResult
    static func addPeg(_ peg: Peg) -> Bool {
        level?.addPeg(peg) ?? false
    }

    @discardableResult
    static func removePeg(_ peg: Peg) -> Peg? {
        level?.removePeg(peg)
    }

    static func removeAllPegs() {
        level?.removeAllPegs()
    }

    @discardableResult
    static func replacePeg(_ peg: Peg, with newPeg: Peg) -> Bool {
        level?.replacePeg(peg, with: newPeg) ?? false
    }

    // MARK: Private methods

    private static func constructLevel(from levelData: LevelData, delegate: LevelDelegate?) -> Level {
        let pegDatas = levelData.pegs.map { constructPeg(from: $0) }
        let level = Level(name: levelData.name,
                          pegs: Set(pegDatas),
                          delegate: delegate)
        return level
    }

    private static func constructPeg(from pegData: PegData) -> Peg {
        guard let type = PegType(rawValue: pegData.type) else {
            // TODO DONT USE FATAL ERROR
            fatalError("An invalid PegType was provided.")
        }

        let peg = Peg(center: CGPoint(x: pegData.centerX, y: pegData.centerY),
                      radius: CGFloat(pegData.radius),
                      type: type)
        return peg
    }
}
