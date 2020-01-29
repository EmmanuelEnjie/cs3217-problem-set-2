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
    var requiredToWin: Bool

    func overlaps(with peg: Peg) -> Bool {
        center.distance(to: peg.center) < radius + peg.radius
    }
}
