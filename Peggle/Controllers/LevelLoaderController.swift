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
    var levels = Store.shared.objects(LevelData.self)
    var levelsObserverToken: NotificationToken?

    override var prefersStatusBarHidden: Bool {
        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        levelsObserverToken = levels.observe { [weak self] (changes: RealmCollectionChange) in
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
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        levels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LevelTableViewCell"
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                as? LevelTableViewCell
        else {
            fatalError("The dequeued cell is not an instance of \(cellIdentifier).")
        }
        let level = levels[indexPath.row]

        cell.levelNameLabel.text = level.name

        return cell
    }

    @IBAction private func createLevel(_ sender: UIBarButtonItem) {
        let createHandler: (String) -> Void = { input in
            do {
                let level = LevelData()
                level.name = input
                let realm = try Realm()
                try realm.write {
                    realm.add(level)
                }
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

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(levels[indexPath.row])
                }
            } catch {
                Dialogs.showAlert(in: self,
                                  title: nil,
                                  message: "An error occured while deleting the level. Please try again",
                                  dismissActionTitle: "OK")
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard
            let row = tableView.indexPathForSelectedRow?.row,
            let levelDesignerController = segue.destination as? LevelDesignerController
        else {
            return
        }
        let levelData = levels[row]
        levelDesignerController.levelData = levelData
    }

}
