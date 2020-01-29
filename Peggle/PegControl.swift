//
//  Peg.swift
//  Peggle
//
//  Created by Shawn Koh on 28/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import UIKit

class PegControl: UIButton {
    // MARK: Initialisers
    required init(peg: Peg) {
        super.init(frame: .zero)
        setImage(UIImage(named: peg.requiredToWin ? "peg-orange" : "peg-blue"), for: .normal)
        bounds.size = peg.size
        center = peg.center
    }

    // Not supported: Initialise via storyboard
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }

    // Restricts the touch hitbox of the peg to a circle
    // Credit: https://stackoverflow.com/questions/37617784/active-clickable-area-for-uibutton-with-rounded-corners
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        UIBezierPath(ovalIn: self.bounds).contains(point)
    }
}
