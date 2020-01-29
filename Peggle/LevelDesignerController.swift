//
//  ViewController.swift
//  Peggle
//
//  Created by Shawn Koh on 27/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import UIKit

class LevelDesignerController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    @IBOutlet weak var createNotRequiredPegTool: UIButton!
    @IBOutlet weak var createRequiredPegTool: UIButton!
    @IBOutlet weak var deletePegTool: UIButton!
    @IBOutlet weak var levelNameTextField: UITextField!
    @IBOutlet weak var canvasControl: UIImageView!

    private(set) var level: Level?

    private var selectedTool: UIButton? {
        willSet {
            selectedTool?.isSelected = false
            selectedTool?.layer.borderWidth = 0
        }
        didSet {
            selectedTool?.isSelected = true
            selectedTool?.layer.borderWidth = 2
        }
    }
    private var pegs: [PegControl: Peg] = [:]
    private var levelName: String? {
        didSet {
            levelNameTextField.text = levelName
        }
    }
    var defaultPegRadius = CGFloat(16)
    var defaultPegSize: CGSize {
        CGSize(width: defaultPegRadius * 2, height: defaultPegRadius * 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        levelNameTextField.delegate = self

        createNotRequiredPegTool.layer.borderColor = UIColor.red.cgColor
        createRequiredPegTool.layer.borderColor = UIColor.red.cgColor
        deletePegTool.layer.borderColor = UIColor.red.cgColor

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(canvasTapped(tapGestureRecognizer:)))
        canvasControl.addGestureRecognizer(tapGestureRecognizer)

        level = level ?? Level(name: "", pegs: [])
        // TODO: Add level loading stuff here
    }

    // MARK: Actions
    @IBAction func selectTool(_ sender: UIButton) {
        if selectedTool == sender {
            selectedTool = nil
        } else {
            selectedTool = sender
        }
    }

    @objc func pegTapped(pegControl: PegControl) {
        guard var peg = pegs[pegControl] else {
            fatalError("pegControl is not found in pegs")
        }
        switch selectedTool {
        case createNotRequiredPegTool:
            peg.requiredToWin = true
            pegControl.setImage(UIImage(named: "peg-blue"), for: .normal)

        case createRequiredPegTool:
            peg.requiredToWin = false
            pegControl.setImage(UIImage(named: "peg-orange"), for: .normal)

        case deletePegTool:
            deletePeg(pegControl: pegControl)

        default:
            ()
        }
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard
            gestureRecognizer.state == .ended,
            let view = gestureRecognizer.view,
            let pegControl = view as? PegControl
        else {
            return
        }
        deletePeg(pegControl: pegControl)
    }

    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard
            let view = gestureRecognizer.view,
            let pegControl = view as? PegControl,
            let peg = pegs[pegControl],
            gestureRecognizer.state == .changed || gestureRecognizer.state == .ended
        else {
            return
        }

        let panCenter = gestureRecognizer.location(in: canvasControl)
        let newPeg = Peg(center: panCenter, radius: peg.radius, requiredToWin: peg.requiredToWin)
        if hasNoOverlaps(peg: newPeg, ignoredPeg: peg) {
            pegControl.center = panCenter
            pegs[pegControl] = newPeg
        }
    }

    @objc func canvasTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard
            selectedTool == createNotRequiredPegTool ||
            selectedTool == createRequiredPegTool
        else {
            return
        }
        let requiredToWin = selectedTool == createRequiredPegTool
        let location = tapGestureRecognizer.location(in: canvasControl)
        let newPeg = Peg(
            center: CGPoint(x: location.x, y: location.y),
            radius: defaultPegRadius,
            requiredToWin: requiredToWin
        )

        guard hasNoOverlaps(peg: newPeg, ignoredPeg: nil) else {
            return
        }
        let pegControl = PegControl(peg: newPeg)
        pegControl.addTarget(self, action: #selector(pegTapped(pegControl:)), for: .touchUpInside)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        pegControl.addGestureRecognizer(longPressGestureRecognizer)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pegControl.addGestureRecognizer(panGestureRecognizer)

        pegs[pegControl] = newPeg
        canvasControl.addSubview(pegControl)
    }


    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        levelNameTextField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        levelName = textField.text
    }

    @IBAction func resetCanvas(_ sender: UIButton) {
        pegs.keys.forEach { $0.removeFromSuperview() }
        pegs = [:]
    }

    private func deletePeg(pegControl: PegControl) {
        pegs.removeValue(forKey: pegControl)
        pegControl.removeFromSuperview()
    }

    private func hasNoOverlaps(peg: Peg, ignoredPeg: Peg?) -> Bool {
        pegs.values
            .filter { ignoredPeg == nil || $0 != ignoredPeg }
            .allSatisfy { !$0.overlaps(with: peg )}
    }
}

