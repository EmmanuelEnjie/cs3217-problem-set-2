//
//  LevelDelegate.swift
//  Peggle
//
//  Created by Shawn Koh on 2/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

protocol LevelDelegate: AnyObject {
    func didAddPeg(_ peg: Peg)
    func didReplacePeg(oldPeg: Peg, newPeg: Peg)
    func didRemovePeg(_ peg: Peg)
    func didRemoveAllPegs()
    func didNameChange(_ name: String)
}
