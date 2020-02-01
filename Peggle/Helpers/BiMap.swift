//
//  File.swift
//  Peggle
//
//  Created by Shawn Koh on 1/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

// A bidirectional map backed by two hash tables.
// This implementation does not allow null keys and values.
// Loosely based on https://guava.dev/releases/23.0/api/docs/com/google/common/collect/HashBiMap.html
struct BiMap<Key: Hashable, Value: Hashable> {
    private var keyToValue: [Key: Value] = [:]
    private var valueToKey: [Value: Key] = [:]

    var isEmpty: Bool {
        keyToValue.isEmpty
    }

    var count: Int {
        keyToValue.count
    }


    func getValueForKey(key: Key) -> Value? {
        keyToValue[key]
    }

    mutating func setValueForKey(key: Key, newValue: Value?) {
        if let currentValue = keyToValue[key] {
            valueToKey[currentValue] = nil
        }

        keyToValue[key] = newValue
        if let newValue = newValue {
            valueToKey[newValue] = key
        }
    }

    func getKeyForValue(value: Value) -> Key? {
        valueToKey[value]
    }

    mutating func setKeyForValue(value: Value, newKey: Key?) {
        if let currentKey = valueToKey[value] {
            keyToValue[currentKey] = nil
        }

        valueToKey[value] = newKey
        if let newKey = newKey {
            keyToValue[newKey] = value
        }
    }

    subscript(key key: Key) -> Value? {
        get {
            getValueForKey(key: key)
        }

        set {
            setValueForKey(key: key, newValue: newValue)
        }
    }

    subscript(value value: Value) -> Key? {
        get {
            getKeyForValue(value: value)
        }

        set(newKey) {
            setKeyForValue(value: value, newKey: newKey)
        }
    }
}
