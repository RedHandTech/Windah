//
//  RHWindowState.swift
//  Windah
//
//  Created by Sanders, Robert on 03/08/2016.
//  Copyright © 2016 Red Hand Technologies. All rights reserved.
//

import Foundation

enum TriggerType {
    case none
    case primary
    case secondary
    case screenChange
}

class RHWindowState {
    
    // MARK: - Public
    
    var location: WindowLocation {
        get {
            return _location
        }
    }
    
    // MARK: - Private
    
    fileprivate var _location: WindowLocation = .none
    
    // MARK: - Constructors
    
    init(location: WindowLocation) {
        _location = location
    }
    
    // MARK: - Public
    
    /**Transitions the window to a new state.*/
    func transition(_ trigger: TriggerType, arrowDirection: Key) -> WindowLocation {
        
        // Decide where to go next
        if trigger == .primary {
            switch arrowDirection {
            case .up:
                _location = .full
                break
            case .down:
                _location = .none
                break
            case .left:
                _location = .left
                break
            case .right:
                _location = .right
                break
            }
        } else if trigger == .secondary {
            switch arrowDirection {
            case .up:
                _location = secondaryTriggerUpArrorwHit()
                break
            case .down:
                _location = secondaryTriggerDownArrorwHit()
                break
            case .left:
                _location = secondaryTriggerLeftArrorwHit()
                break
            case .right:
                _location = secondaryTriggerRightArrorwHit()
                break
            }
        }

        return _location
    }
    
    // MARK: - Private
    
    fileprivate func secondaryTriggerLeftArrorwHit() -> WindowLocation {
        
        // Make descision based on current location
        switch _location {
        case .full, .left, .right, .topLeft, .topRight, .none:
            return .topLeft
        case .bottomLeft:
            return .bottomLeft
        case .bottomMiddle:
            return .bottomLeft
        case .bottomRight:
            return .bottomMiddle
        }
    }
    
    fileprivate func secondaryTriggerRightArrorwHit() -> WindowLocation {
        
        // Make descision based on current location
        switch _location {
        case .full, .left, .right, .topLeft, .topRight, .none:
            return .topRight
        case .bottomLeft:
            return .bottomMiddle
        case .bottomMiddle:
            return .bottomRight
        case .bottomRight:
            return .bottomRight
        }
    }
    
    fileprivate func secondaryTriggerUpArrorwHit() -> WindowLocation {
        
        // Make descision based on current location
        switch _location {
        case .full, .left, .topLeft, .bottomLeft, .bottomMiddle, .none:
            return .topLeft
        case .right, .topRight, .bottomRight:
            return .topRight
        }
    }
    
    fileprivate func secondaryTriggerDownArrorwHit() -> WindowLocation {
        
        // Make descision based on current location
        switch _location {
        case .full, .left, .topLeft, .bottomLeft, .none:
            return .bottomLeft
        case .right, .topRight, .bottomRight:
            return .bottomRight
        case .bottomMiddle:
            return .bottomMiddle
        }
    }
    
}





































