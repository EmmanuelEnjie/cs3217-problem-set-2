//
//  Settings.swift
//  Peggle
//
//  Created by Shawn Koh on 1/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import UIKit

// Global level settings for the `Peggle` application.
final class Settings {
    static let defaultPegRadius = CGFloat(16)
    static var defaultPegSize: CGSize {
        CGSize(width: defaultPegRadius * 2, height: defaultPegRadius * 2)
    }
    static let objectivePegImage = UIImage(named: "peg-orange")
    static let normalPegImage = UIImage(named: "peg-blue")

    // Prevent the `Settings` singleton from being initialised.
    private init() {}
}
