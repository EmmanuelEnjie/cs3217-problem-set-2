//
//  File.swift
//  Peggle
//
//  Created by Shawn Koh on 1/2/20.
//  Copyright © 2020 Shawn Koh. All rights reserved.
//

/**
 A `BiMap` is a bidirectional map backed by two hash tables.

 This implementation does not allow null keys and values.
 Loosely based on https://github.com/mauriciosantos/Buckets-Swift/blob/master/Source/Bimap.swift
 */
struct BiMap<Key: Hashable, Value: Hashable> {
    private var keyToValue: [Key: Value] = [:]
    private var valueToKey: [Value: Key] = [:]

    /// - returns: A collection containing just the keys of the bimap.
    var keys: Dictionary<Key, Value>.Keys {
        keyToValue.keys
    }

    /// - returns: A collection containing just the values of the bimap.
    var values: Dictionary<Key, Value>.Values {
        keyToValue.values
    }

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
