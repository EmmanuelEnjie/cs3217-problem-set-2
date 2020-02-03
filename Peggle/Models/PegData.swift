//
//  PegData.swift
//  Peggle
//
//  Created by Shawn Koh on 2/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import CoreGraphics
import RealmSwift

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

    required init() {
        super.init()
    }

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

    convenience init(peg: Peg) {
        self.init(centerX: Double(peg.center.x),
                  centerY: Double(peg.center.y),
                  radius: Double(peg.radius),
                  type: peg.type.rawValue)
    }
}
