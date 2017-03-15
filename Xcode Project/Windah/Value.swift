//
//  Value.swift
//  RHNotify
//
//  Created by Sanders, Robert on 19/08/2016.
//  Copyright © 2016 Red Hand Technologies. All rights reserved.
//

/**Value is the core RHNotify class and is a bag for holding observable values.*/
class Value<T> {
    
    // MARK: - Public
    
    /**The value.*/
    var value: T {
        get {
            return _value
        } set {
            _value = newValue
        }
    }
    
    // MARK: - Private
    
    fileprivate var _value: T {
        didSet {
            // Set old value
            _oldValue = oldValue
            // Perform updates
            performUpdates()
        }
    }
    
    fileprivate var _oldValue: T?
    
    fileprivate var _observers: [Observer<T>] = []
    fileprivate var _callbacks: [((_ value: T) -> ())] = []
    fileprivate var _chainables: [Chainable<T>] = []
    
    // MARK: - Constructors
    
    init(value: T) {
        _value = value
    }
    
    // MARK: - Public
    
    /**Begins a filter chain. Set the filter predicates on the filterer returned.*/
    func onWhere(_ predicate: @escaping (_ value: T) -> Bool) -> Filterer<T> {
        
        let filterer = Filterer(predicate: predicate)
        _chainables += [filterer]
        
        return filterer
    }
    
    /**Begins a mapper chain. NOTE: Cannot filter after mapping. Need to filter first. See README.*/
    func map<U>(_ mapper: @escaping (_ value: T) -> U) -> Mapper<T, U> {
        
        let map = Mapper(mapper: mapper)
        _chainables += [map]
        return map
    }
    
    /**Binds the value in observer to the value.*/
    func observe(_ observer: Observer<T>) {
        _observers += [observer]
    }
    
    /**The callback is called every time the value changes.*/
    func observe(_ callback: @escaping (_ value: T) -> ()) {
        _callbacks += [callback]
    }
    
    // MARK: - Private
    
    fileprivate func performUpdates() {
        
        // Update observers
        for o in _observers {
            o.update(_value)
        }
        
        // Trigger callbacks
        for c in _callbacks {
            c(_value)
        }
        
        // Start chains
        for c in _chainables {
            c.triggerChain(_value)
        }
    }
    
}



































































