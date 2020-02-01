//
//  Peg.swift
//  Peggle
//
//  Created by Shawn Koh on 28/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import UIKit

class PegControl: UIButton {
    // MARK: Properties
    var image: UIImage?
    var radius: CGFloat

    // MARK: Initialisers
    required init(center: CGPoint, radius: CGFloat, image: UIImage?) {
        self.radius = radius
        self.image = image
        super.init(frame:. zero)
        self.center = center

        reload()
    }

    // Not supported: Initialise via storyboard
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }

    func reload() {
        setImage(image, for: .normal)
        let diameter = radius * 2
        bounds.size = CGSize(width: diameter, height: diameter)
    }

    // Restricts the touch hitbox of the peg to a circle
    // Credit: https://stackoverflow.com/questions/37617784/active-clickable-area-for-uibutton-with-rounded-corners
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        UIBezierPath(ovalIn: self.bounds).contains(point)
    }
}


