//
//  ViewController.swift
//  Peggle
//
//  Created by Shawn Koh on 27/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import UIKit

class LevelDesignerController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var normalPegTool: UIButton!
    @IBOutlet weak var objectivePegTool: UIButton!
    @IBOutlet weak var deletePegTool: UIButton!
    @IBOutlet weak var levelNameTextField: UITextField!
    @IBOutlet weak var canvasControl: UIImageView!

    var level: Level?
    var pegs: BiMap<Peg, PegControl> = BiMap()
    var pegTools: [UIButton] = []
    var selectedPegTool: UIButton? {
        willSet {
            selectedPegTool?.isSelected = false
            selectedPegTool?.layer.borderWidth = 0
        }
        didSet {
            selectedPegTool?.isSelected = true
            selectedPegTool?.layer.borderWidth = Settings.selectedPegToolBorderWidth
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        levelNameTextField.delegate = self
        pegTools = [normalPegTool, objectivePegTool, deletePegTool]
        pegTools.forEach { $0.layer.borderColor = Settings.selectedPegToolBorderColor }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(canvasTapped(tapGestureRecognizer:)))
        canvasControl.addGestureRecognizer(tapGestureRecognizer)

        level = level ?? Level(name: "", pegs: [])
        level?.delegate = self
        // TODO: Add level loading stuff here
    }

    // MARK: Actions
    @IBAction func selectTool(_ sender: UIButton) {
        guard pegTools.contains(sender) else {
            fatalError("A UIButton \(sender) that is not a tool has been selected.")
        }

        if selectedPegTool == sender {
            selectedPegTool = nil
        } else {
            selectedPegTool = sender
        }
    }

    @objc func canvasTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard
            selectedPegTool == normalPegTool ||
            selectedPegTool == objectivePegTool
        else {
            return
        }

        let location = tapGestureRecognizer.location(in: canvasControl)
        let peg = Peg(
            center: CGPoint(x: location.x, y: location.y),
            radius: Settings.defaultPegRadius,
            type: selectedPegTool == normalPegTool ? .normal : .objective
        )
        _ = level?.addPeg(peg)
    }

    @IBAction func resetCanvas(_ sender: UIButton) {
        canvasControl.subviews.forEach { $0.removeFromSuperview() }
        level?.removeAllPegs()
    }
}

extension LevelDesignerController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard
            let name = textField.text,
            name != ""
        else {
            return false
        }
        levelNameTextField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        level?.name = textField.text!
    }
}
