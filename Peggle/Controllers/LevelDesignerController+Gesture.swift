//
//  LevelDesignerController+Gesture.swift
//  Peggle
//
//  Created by Shawn Koh on 1/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import UIKit

extension LevelDesignerController {
    @objc func levelNameTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        Dialogs.showPrompt(in: self,
                           title: "Level Name",
                           message: "Please enter a level name.",
                           confirmActionTitle: "Save",
                           placeholder: "Please enter a level name",
                           initialValue: level?.name ?? "",
                           confirmHandler: { input in
                             self.level?.name = input
        })
    }

    @objc func canvasTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard
            selectedPegTool == normalPegTool ||
            selectedPegTool == objectivePegTool
        else {
            return
        }

        let tapLocation = tapGestureRecognizer.location(in: canvasControl)
        let peg = Peg(center: tapLocation,
                      radius: Settings.defaultPegRadius,
                      type: selectedPegTool == normalPegTool ? .normal : .objective)
        level?.addPeg(peg)
    }

    @objc func handlePegTap(pegControl: PegControl) {
        guard let peg = pegs[value: pegControl] else {
            fatalError("pegControl is not found in pegs")
        }

        switch selectedPegTool {
        case normalPegTool:
            var newPeg = peg
            newPeg.type = .normal
            level?.replacePeg(peg, with: newPeg)

        case objectivePegTool:
            var newPeg = peg
            newPeg.type = .objective
            level?.replacePeg(peg, with: newPeg)

        case deletePegTool:
            level?.removePeg(peg)

        default:
            ()
        }
    }

    @objc func handlePegLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard
            gestureRecognizer.state == .ended,
            let view = gestureRecognizer.view,
            let pegControl = view as? PegControl,
            let peg = pegs[value: pegControl]
        else {
            return
        }
        level?.removePeg(peg)
    }

    @objc func handlePegPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard
            let view = gestureRecognizer.view,
            let pegControl = view as? PegControl,
            let peg = pegs[value: pegControl],
            gestureRecognizer.state == .changed || gestureRecognizer.state == .ended
        else {
            return
        }

        let panCenter = gestureRecognizer.location(in: canvasControl)
        var newPeg = peg
        newPeg.center = panCenter
        level?.replacePeg(peg, with: newPeg)
    }
}
