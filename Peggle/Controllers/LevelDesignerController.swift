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
    // swiftlint:disable private_outlet
    @IBOutlet var levelNameLabel: UILabel!
    @IBOutlet var normalPegTool: UIButton!
    @IBOutlet var objectivePegTool: UIButton!
    @IBOutlet var deletePegTool: UIButton!
    @IBOutlet var canvasControl: UIImageView!
    // swiftlint:enable private_outlet

    var level: Level?
    var levelNamePrompt: UIAlertController?
    var levelNamePromptObserver: NSObjectProtocol?
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

        level = level ?? Level(name: "", pegs: [])
        level?.delegate = self
        // TODO: Add level loading stuff here

        levelNamePrompt = UIAlertController(title: "Please enter a level name.", message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: { _ in
                                        guard let input = self.levelNamePrompt?.textFields?[0].text else {
                                            fatalError("The textField cannot be accessed.")
                                        }
                                        self.level?.name = input
        })
        saveAction.isEnabled = self.level?.name.isEmpty ?? false
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        levelNamePrompt?.addTextField { textField in
            textField.placeholder = "Please enter a level name."
            textField.text = self.level?.name
            // Prevents the user from saving if the text field is empty.
            // Credit: https://gist.github.com/TheCodedSelf/c4f3984dd9fcc015b3ab2f9f60f8ad51
            self.levelNamePromptObserver = NotificationCenter.default.addObserver(
                forName: UITextField.textDidChangeNotification,
                object: textField,
                queue: .main,
                using: { _ in
                    let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    saveAction.isEnabled = textIsNotEmpty
                }
            )
        }
        levelNamePrompt?.addAction(saveAction)
        levelNamePrompt?.addAction(cancelAction)

        pegTools = [normalPegTool, objectivePegTool, deletePegTool]
        pegTools.forEach { $0.layer.borderColor = Settings.selectedPegToolBorderColor }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(canvasTapped(tapGestureRecognizer:)))
        canvasControl.addGestureRecognizer(tapGestureRecognizer)

        levelNameLabel.isUserInteractionEnabled = true
        let levelNameGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(levelNameTapped(tapGestureRecognizer:)))
        levelNameLabel.addGestureRecognizer(levelNameGestureRecognizer)
    }

    override var prefersStatusBarHidden: Bool {
        true
    }

    // MARK: Actions
    @IBAction private func selectTool(_ sender: UIButton) {
        guard pegTools.contains(sender) else {
            fatalError("A UIButton \(sender) that is not a tool has been selected.")
        }

        if selectedPegTool == sender {
            selectedPegTool = nil
        } else {
            selectedPegTool = sender
        }
    }

    @IBAction private func resetCanvas(_ sender: UIButton) {
        canvasControl.subviews.forEach { $0.removeFromSuperview() }
        level?.removeAllPegs()
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
        level?.addPeg(peg)
    }
}
