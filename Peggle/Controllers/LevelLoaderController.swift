//
//  LevelSelectorController.swift
//  Peggle
//
//  Created by Shawn Koh on 3/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import UIKit
import RealmSwift

class LevelLoaderController: UITableViewController {
    var levelsObserverToken: NotificationToken?

    override var prefersStatusBarHidden: Bool {
        true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Store.levelDatas.count
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Observes the Store's level
        levelsObserverToken = Store.levelDatas.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else {
                return
            }
            switch changes {
            case .initial:
                tableView.reloadData()
            case let .update(_, deletions, insertions, modifications):
                tableView.beginUpdates()
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("An error occured while opening the Realm file on the background worker thread: \(error)")
            }
        }

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LevelTableViewCell"
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                as? LevelTableViewCell
        else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        let level = Store.levelDatas[indexPath.row]

        cell.levelNameLabel.text = level.name

        return cell
    }

    @IBAction private func createLevel(_ sender: UIBarButtonItem) {
        let createHandler: (String) -> Void = { input in
            do {
                let levelData = LevelData()
                levelData.name = input
                try Store.saveLevelData(levelData)
            } catch {
                Dialogs.showAlert(in: self,
                                  title: nil,
                                  message: "An error occured while creating a level.",
                                  dismissActionTitle: "OK")
            }
        }

        Dialogs.showPrompt(in: self,
                           title: "Level Name",
                           message: nil,
                           confirmActionTitle: "Create",
                           placeholder: "Please enter a level name.",
                           initialValue: "",
                           confirmHandler: createHandler
        )
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let levelData = Store.levelDatas[indexPath.row]
                try Store.removeLevelData(levelData)
            } catch {
                Dialogs.showAlert(in: self,
                                  title: nil,
                                  message: "An error occured while deleting the level. Please try again",
                                  dismissActionTitle: "OK")
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let row = tableView.indexPathForSelectedRow?.row,
            segue.destination as? LevelDesignerController != nil
        else {
            return
        }
        let levelData = Store.levelDatas[row]
        LevelDesigner.loadLevelData(levelData, levelDelegate: nil)
    }
}
