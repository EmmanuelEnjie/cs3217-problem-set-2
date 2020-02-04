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

    
    /// Detect view load state and initialize level editor
    override func viewDidLoad() {
        super.viewDidLoad()

        // Generate interaction controls
        pegTool = [normalPegTool, objectivePegTool, deletePegTool]
        pegTool.forEach { $0.layer.borderColor = Settings.selectedPegToolBorderColor }

        // Init main level gesture detection
        let levelTouch = UITapGestureRecognizer(target: self, action: #selector(canvasTapped(tapGestureRecognizer:)))
        canvasControl.addGestureRecognizer(levelTouch)

        // Enable user input
        levelNameLabel.isUserInteractionEnabled = true
        
        // Init name label gesture detection
        let nameTouch = UITapGestureRecognizer(target: self, action: #selector(levelNameTapped(tapGestureRecognizer:)))
        levelNameLabel.addGestureRecognizer(nameTouch)

        // Bind self to level
        LevelDesigner.setup(levelDelegate: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        LevelDesigner.removeAllPegs()
    }

    @IBAction private func saveLevel(_ sender: Any) {
        do {
            try LevelDesigner.saveLevelData()
        } catch {
            Dialogs.showAlert(in: self,
                              title: nil,
                              message: "An unexpected error occured when saving the level. Please try again.",
                              dismissActionTitle: "OK")
        }
    }
}
