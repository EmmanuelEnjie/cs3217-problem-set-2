//
//  PegData.swift
//  Peggle
//
//  Created by Shawn Koh on 2/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import RealmSwift

/**
 `PegData` represents a Realm model object for the abstract data structure `Peg`.
 It is intended to be used for persisting `Peg`s.
 */
class PegData: Object {
    override class func primaryKey() -> String? {
        "id"
    }

    // Realm has no auto-incrementing properties, so generate a unique string ID.
    // More info here: https://realm.io/docs/swift/latest#limitations-models
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var centerX = Double()
    @objc dynamic var centerY = Double()
    @objc dynamic var radius = Double()
    @objc dynamic var type: Int = 0

    /// Constructs an empty `PegData`.
    required init() {
        super.init()
    }

    /// Constructs a new `PegData`.
    /// - Parameters:
    ///     - centerX: The x position of the peg's center.
    ///     - centerY: The y position of the peg's center.
    ///     - radius: The radius of the peg.
    ///     - type: An integer representing the peg's `PegType`.
    init(centerX: Double, centerY: Double, radius: Double, type: Int) {
        guard PegType(rawValue: type) != nil else {
            fatalError("An incorrect PegType was provided.")
        }
        super.init()
        self.centerX = centerX
        self.centerY = centerY
        self.radius = radius
        self.type = type
    }

    /// Constructs a new `PegData`.
    /// - Parameter peg: A peg abstract data structure.
    convenience init(peg: Peg) {
        self.init(centerX: Double(peg.center.x),
                  centerY: Double(peg.center.y),
                  radius: Double(peg.radius),
                  type: peg.type.rawValue)
    }
}
