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

    init(center: CGPoint, radius: CGFloat, type: PegType) {
        self.center = center
        self.radius = radius
        self.type = type
    }

    init(pegData: PegData) {
        guard let type = PegType(rawValue: pegData.type) else {
            fatalError("An invalid PegType was provided.")
        }
        self.center = CGPoint(x: pegData.centerX, y: pegData.centerY)
        self.radius = CGFloat(pegData.radius)
        self.type = type
    }
}

extension Peg: Hashable {}
