//
//  Chaining.swift
//  RHNotify
//
//  Created by Robert Sanders on 21/08/2016.
//  Copyright © 2016 Red Hand Technologies. All rights reserved.
//

internal class Chainable<T> {
    
    // MARK: - Public
    
    var value: T? {
        get {
            return _value
        } set {
            _value = newValue
        }
    }
    
    // MARK: - Internal
    
    internal var _value: T?
    internal var nextItem: Chainable?
    
    // MARK: - Internal
    
    internal func triggerChain(_ latestValue: T) {
        _value = latestValue
    }
}

















































