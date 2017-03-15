//
//  Mapper.swift
//  RHNotify
//
//  Created by Robert Sanders on 21/08/2016.
//  Copyright © 2016 Red Hand Technologies. All rights reserved.
//

class Mapper<T, U>: Chainable<T> {
    
    // MARK: - Private
    
    fileprivate var _mappable: ((_ value: T) -> U)?
    
    fileprivate var _observer: Observer<U>?
    fileprivate var _callback: ((_ value: U) -> ())?
    
    fileprivate var _nextFilterer: Filterer<U>?
    fileprivate var _nextMapper: Chainable<U>?
    
    // MARK: - Constructors
    
    init (mapper: @escaping (_ value: T) -> U) {
        _mappable = mapper
    }
    
    // MARK: - Public
    
    func onWhere(_ predicate: @escaping (_ value: U) -> Bool) -> Filterer<U> {
        
        let filterer: Filterer<U> = Filterer(predicate: predicate)
        _nextFilterer = filterer
        
        return filterer
    }
    
    func map<V>(_ mapper: @escaping (_ value: U) -> V) -> Mapper<U, V> {
        
        let map = Mapper<U, V>(mapper: mapper)
        _nextMapper = map
        
        return map
    }
    
    func observe(_ observer: Observer<U>) {
        _observer = observer
    }
    
    func observe(_ callback: @escaping (_ value: U) -> ()) {
        _callback = callback
    }
    
    // MARK: - Overrides
    
    internal override func triggerChain(_ latestValue: T) {
        
        super.triggerChain(latestValue)
        
        // Perform mapping changes
        guard let value = value else { return }
        guard let mappedValue = _mappable?(value) else { return }
        
        // Check next items
        if let _nextFilterer = _nextFilterer {
            _nextFilterer.triggerChain(mappedValue)
            return
        } else if let _nextMapper = _nextMapper {
            _nextMapper.triggerChain(mappedValue)
            return
        }
        
        // Observer and callbacks if no next item
        _observer?.update(mappedValue)
        _callback?(mappedValue)
    }
}

















