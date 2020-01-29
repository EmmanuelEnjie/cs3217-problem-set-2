//
//  CGPoint+Distance.swift
//  Peggle
//
//  Created by Shawn Koh on 29/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        hypot(from.x - to.x, from.y - to.y)
    }
}
