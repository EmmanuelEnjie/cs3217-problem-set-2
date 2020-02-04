//
//  Peg.swift
//  Peggle
//
//  Created by Shawn Koh on 27/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import CoreGraphics

/**
 `Peg` is an abstract data structure that represents a peg in Peggle.
*/
struct Peg {
    var center: CGPoint
    var radius: CGFloat
    var type: PegType

    func overlaps(with peg: Peg) -> Bool {
        center.distance(to: peg.center) < radius + peg.radius
    }

    init(center: CGPoint, radius: CGFloat, type: PegType) {
        self.center = center
        self.radius = radius
        self.type = type
    }
}

extension Peg: Hashable {}
