//
//  PegType.swift
//  Peggle
//
//  Created by Shawn Koh on 3/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

/**
 The `PegType` enumeration represents the various types of pegs in Peggle.
 */
enum PegType: Int {
    /// An `objective` peg has to be eliminated in order to complete the level.
    /// When it is eliminated, it provides points.
    case objective
    /// A `normal` peg does not need to be eliminated in order to complete the level.
    /// When it is eliminated, it provides points.
    case normal
}
