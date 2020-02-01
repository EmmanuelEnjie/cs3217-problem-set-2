//
//  CGPoint+Distance.swift
//  Peggle
//
//  Created by Shawn Koh on 29/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    public func distance(to: CGPoint) -> CGFloat {
        hypot(x - to.x, y - to.y)
    }
}
