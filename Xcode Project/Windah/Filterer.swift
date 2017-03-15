//
//  Filterer.swift
//  RHNotify
//
//  Created by Robert Sanders on 21/08/2016.
//  Copyright © 2016 Red Hand Technologies. All rights reserved.
//

internal class Filterer<T>: Chainable<T> {
    
    // MARK: - Private
    
    fileprivate var _predicate: (_ value: T) -> Bool
    
    fileprivate var _observer: Observer<T>?
    fileprivate var _callback: ((_ value: T) -> ())?
    
    // MARK: - Constructors
    
    init(predicate: @escaping (_ valie: T) -> Bool) {
        _predicate = predicate
        
        super.init()
    }
    
    // MARK: - Public
    
    func onWhere(_ predicate: @escaping (_ value: T) -> Bool) -> Filterer<T> {
        
        let filterer = Filterer(predicate: predicate)
        nextItem = filterer
        
        return filterer
    }
    
    func map<U>(_ mapper: @escaping (_ value: T) -> U) -> Mapper<T, U> {
        
        let map = Mapper(mapper: mapper)
        nextItem = map
        
        return map
    }
    
    func observe(_ observer: Observer<T>) {
        _observer = observer
    }
    
    func observe(_ callback: @escaping (_ value: T) -> ()) {
        _callback = callback
    }
    
    // MARK: - Overrides
    
    internal override func triggerChain(_ latestValue: T) {
        
        super.triggerChain(latestValue)
        
        guard let value = value else { return }
        
        // Perform filtering changes
        if _predicate(value) == false {
            // Failed check
            return
        }
        
        // Check for next item
        if let item = nextItem {
            item.triggerChain(latestValue)
            // Dont need to continue
            return
        }
        
        // If not next item check for observer and callbacks
        _observer?.update(value)
        _callback?(value)
    }
}

