//
//  Peg.swift
//  Peggle
//
//  Created by Shawn Koh on 27/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import CoreGraphics

struct Peg {
    var center: CGPoint
    var radius: CGFloat
    var type: PegType

    func overlaps(with peg: Peg) -> Bool {
        center.distance(to: peg.center) < radius + peg.radius
    }
}

extension Peg: Hashable {}

// In Peggle, all Objective pegs have to be eliminated in order to win the level.
enum PegType {
    case objective
    case normal
}
