//
//  LevelDesignerController+LevelDelegate.swift
//  Peggle
//
//  Created by Shawn Koh on 1/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import UIKit

extension LevelDesignerController: LevelDelegate {
    func didAddPeg(_ peg: Peg) {
        let image = peg.type == .objective ? Settings.objectivePegImage : Settings.normalPegImage
        let pegControl = PegControl(center: peg.center, radius: peg.radius, image: image)

        pegControl.addTarget(self, action: #selector(handlePegTap(pegControl:)), for: .touchUpInside)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: #selector(handlePegLongPress(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePegPan(_:)))
        pegControl.addGestureRecognizer(longPressGestureRecognizer)
        pegControl.addGestureRecognizer(panGestureRecognizer)

        canvasControl.addSubview(pegControl)
        pegs[key: peg] = pegControl
    }

    func didReplacePeg(oldPeg: Peg, newPeg: Peg) {
        let pegControl = pegs[key: oldPeg]
        pegs[key: oldPeg] = nil
        pegs[key: newPeg] = pegControl

        pegControl?.center = newPeg.center
        pegControl?.radius = newPeg.radius
        pegControl?.image = newPeg.type == .objective ? Settings.objectivePegImage : Settings.normalPegImage
        pegControl?.reload()
    }

    func didRemovePeg(_ peg: Peg) {
        let pegControl = pegs[key: peg]
        pegControl?.removeFromSuperview()
        pegs[key: peg] = nil
    }

    func didRemoveAllPegs() {
        pegs.values.forEach { pegControl in
            pegControl.removeFromSuperview()
        }
        pegs = BiMap()
    }

    func didNameChange(_ name: String) {
        levelNameLabel.text = name
    }
}
