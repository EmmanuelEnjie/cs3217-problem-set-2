//
//  LevelDesignerState.swift
//  Peggle
//
//  Created by Shawn Koh on 4/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

/// This struct represents the local state of the level designer.
struct LevelDesignerState {
    private init() {}
    static var level: Level?
    static var levelData: LevelData?
}
