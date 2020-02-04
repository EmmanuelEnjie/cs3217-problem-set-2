//
//  Level.swift
//  Peggle
//
//  Created by Shawn Koh on 27/1/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import CoreGraphics

struct Level {
    // MARK: Properties
    var name: String {
        didSet {
            delegate?.didNameChange(name)
        }
    }
    var pegs: Set<Peg>
    weak var delegate: LevelDelegate?

    init(name: String, pegs: Set<Peg>, delegate: LevelDelegate?) {
        self.name = name
        self.pegs = pegs
        self.delegate = delegate

        delegate?.didNameChange(name)
        pegs.forEach { peg in
            delegate?.didAddPeg(peg)
        }
    }

    func hasNoOverlappingPegs(peg: Peg, ignoredPeg: Peg?) -> Bool {
        pegs.filter { ignoredPeg == nil || $0 != ignoredPeg }
            .allSatisfy { !$0.overlaps(with: peg) }
    }

    func canAddPeg(_ peg: Peg) -> Bool {
        hasNoOverlappingPegs(peg: peg, ignoredPeg: nil)
    }

    @discardableResult
    mutating func addPeg(_ peg: Peg) -> Bool {
        guard canAddPeg(peg) else {
            return false
        }
        pegs.insert(peg)
        delegate?.didAddPeg(peg)
        return true
    }

    /**
     Removes the given element and any elements subsumed by the given element.
     */
    @discardableResult
    mutating func removePeg(_ peg: Peg) -> Peg? {
        let removedPeg = pegs.remove(peg)
        if removedPeg != nil {
            delegate?.didRemovePeg(peg)
        }
        return removedPeg
    }

    mutating func removeAllPegs() {
        pegs = []
        delegate?.didRemoveAllPegs()
    }

    @discardableResult
    mutating func replacePeg(_ peg: Peg, with newPeg: Peg) -> Bool {
        guard hasNoOverlappingPegs(peg: newPeg, ignoredPeg: peg) else {
            return false
        }
        pegs.remove(peg)
        pegs.insert(newPeg)
        delegate?.didReplacePeg(oldPeg: peg, newPeg: newPeg)
        return true
    }
}
