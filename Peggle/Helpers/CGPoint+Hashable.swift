//
//  CGPoint+Hashable.swift
//  Peggle
//
//  Created by Shawn Koh on 30/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import CoreGraphics

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
