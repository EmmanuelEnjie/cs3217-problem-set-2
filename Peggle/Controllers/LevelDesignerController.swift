//
//  ViewController.swift
//  Peggle
//
//  Created by Shawn Koh on 27/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import UIKit
import RealmSwift

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
    var levelData: LevelData?
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

        // Set up tools
        pegTools = [normalPegTool, objectivePegTool, deletePegTool]
        pegTools.forEach { $0.layer.borderColor = Settings.selectedPegToolBorderColor }

        let canvasGestureRecognizer = UITapGestureRecognizer(target: self,
                                                             action: #selector(canvasTapped(tapGestureRecognizer:)))
        canvasControl.addGestureRecognizer(canvasGestureRecognizer)

        levelNameLabel.isUserInteractionEnabled = true
        let levelNameGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(levelNameTapped(tapGestureRecognizer:)))
        levelNameLabel.addGestureRecognizer(levelNameGestureRecognizer)

        // Load level
        if let levelData = levelData {
            let pegs = levelData.pegs.map { pegData in
                Peg(pegData: pegData)
            }
            level = Level(name: levelData.name, pegs: Set(pegs), delegate: self)
        } else {
            level = Level(name: Settings.defaultLevelName, pegs: Set(), delegate: self)
        }
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
        level?.removeAllPegs()
    }

    @IBAction private func saveLevel(_ sender: Any) {
        guard let level = level else {
            fatalError("Level could not be accessed.")
        }
        do {
            let realm = try Realm()
            try realm.write {
                let levelData = self.levelData ?? LevelData()
                if self.levelData == nil {
                    realm.add(levelData)
                    self.levelData = levelData
                }

                let pegDatas = pegs.keys.map { PegData(peg: $0) }
                levelData.name = level.name
                levelData.pegs.removeAll()
                levelData.pegs.append(objectsIn: pegDatas)
            }
        } catch {
            Dialogs.showAlert(in: self,
                              title: nil,
                              message: "An unexpected error occured when saving the level. Please try again.",
                              dismissActionTitle: "OK")
        }
    }
}
