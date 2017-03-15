//
//  Observer.swift
//  RHNotify
//
//  Created by Robert Sanders on 21/08/2016.
//  Copyright © 2016 Red Hand Technologies. All rights reserved.
//

class Observer<T> {
    
    // MARK: - Public
    
    var value: T {
        get {
            return _value
        }
    }
    
    /**An optional callback that is triggered every time the value is updated*/
    var callback: ((_ value: T) -> ())?
    
    // MARK: - Private
    
    fileprivate var _value: T
    
    // MARK: - Constructors
    
    init(value: T) {
        _value = value
    }
    
    // MARK: - Internal
    
    internal func update(_ value: T) {
        _value = value
        callback?(_value)
    }
    
}
