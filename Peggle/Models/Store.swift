//
//  Store.swift
//  Peggle
//
//  Created by Shawn Koh on 3/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

import RealmSwift

struct Store {
    static let shared = Store().realm
    private var realm: Realm

    private init() {
        do {
            realm = try Realm()
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
}
