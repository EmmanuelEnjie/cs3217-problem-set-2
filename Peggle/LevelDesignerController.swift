//
//  ViewController.swift
//  Peggle
//
//  Created by Shawn Koh on 27/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import UIKit

enum SelectedMode {
    case createBluePeg
    case createOrangePeg
    case deletePeg
}

class LevelDesignerController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    @IBOutlet weak var createNotRequiredPegTool: UIButton!
    @IBOutlet weak var createRequiredPegTool: UIButton!
    @IBOutlet weak var deletePegTool: UIButton!
    @IBOutlet weak var levelNameTextField: UITextField!
    @IBOutlet weak var canvasControl: UIImageView!

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

    override func viewDidLoad() {
        super.viewDidLoad()
        levelNameTextField.delegate = self

        createNotRequiredPegTool.layer.borderColor = UIColor.red.cgColor
        createRequiredPegTool.layer.borderColor = UIColor.red.cgColor
        deletePegTool.layer.borderColor = UIColor.red.cgColor

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(canvasTapped(tapGestureRecognizer:)))
        canvasControl.addGestureRecognizer(tapGestureRecognizer)
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
            pegs.removeValue(forKey: pegControl)
            pegControl.removeFromSuperview()

        default:
            ()
        }
    }

    @objc func canvasTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard selectedTool == createNotRequiredPegTool || selectedTool == createRequiredPegTool else {
            return
        }
        let location = tapGestureRecognizer.location(in: canvasControl)
        let requiredToWin = selectedTool == createRequiredPegTool
        let peg = Peg(
            center: CGPoint(x: location.x, y: location.y),
            size: CGSize(width: 32, height: 32),
            requiredToWin: requiredToWin
        )
        let pegControl = PegControl(peg: peg)
        pegControl.addTarget(self, action: #selector(pegTapped(pegControl:)), for: .touchUpInside)
        pegs[pegControl] = peg
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

    private func resetCanvas() {
        pegs.keys.forEach { $0.removeFromSuperview() }
        pegs = [:]
    }
}

