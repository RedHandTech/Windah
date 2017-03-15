//
//  RHWindowLocationDetector.swift
//  Windah
//
//  Created by Sanders, Robert on 02/08/2016.
//  Copyright © 2016 Red Hand Technologies. All rights reserved.
//

import Foundation

enum WindowLocation {
    case full
    case left
    case right
    case topLeft
    case topRight
    case bottomLeft
    case bottomMiddle
    case bottomRight
    case none
}

class RHWindowLocationDetector {
    
    // MARK: - Class Funcs
    
    class func analyzeWindowPosition(_ windowFrame: CGRect, screenFrame: CGRect, mainScreenFrame: CGRect) -> WindowLocation {
        
        let detector = RHWindowLocationDetector(windowFrame: windowFrame, screenFrame: screenFrame, masterScreenFrame: mainScreenFrame)
        return detector.windowLocation
    }
    
    class func retrievePossibleWindowFrames(_ screenFrame: CGRect, mainScreenFrame: CGRect) -> [WindowLocation: CGRect] {
        
        let detector = RHWindowLocationDetector(windowFrame: CGRect.zero, screenFrame: screenFrame, masterScreenFrame: mainScreenFrame)
        return detector.possibleWindowFrames
    }
    
    // MARK: - Public
    
    var windowFrame: CGRect? {
        didSet {
            _possibleWindowFrames = calculateFramesForLocations()
        }
    }
    
    var screen: CGRect? {
        didSet {
            _possibleWindowFrames = calculateFramesForLocations()
        }
    }
    
    var masterScreen: CGRect? {
        didSet {
            _possibleWindowFrames = calculateFramesForLocations()
        }
    }
    
    var windowLocation: WindowLocation {
        get {
            return getLocation().location
        }
    }
    
    var possibleWindowFrames: [WindowLocation: CGRect] {
        get {
            return _possibleWindowFrames
        }
    }
    
    // MARK: - Private
    
    fileprivate var _possibleWindowFrames: [WindowLocation: CGRect] = [:]
    
    // MARK: - Constructors
    
    init(windowFrame: CGRect, screenFrame: CGRect, masterScreenFrame: CGRect) {
        
        self.windowFrame = windowFrame
        self.screen = screenFrame
        self.masterScreen = masterScreenFrame
        self._possibleWindowFrames = self.calculateFramesForLocations()
    }
    
    // MARK: - Public
    
    func getLocation() -> (location: WindowLocation, trueMatch: Bool) {
        
        guard let windowFrame = windowFrame else { return (.none, false) }
        
        for pair in _possibleWindowFrames {
            
            // Chcek for true match (can have tolerance of 15 pts in each direction)
            if frameMatches(windowFrame, comparison: pair.1, tolerance: 50) {
                return (pair.0, true)
            }
        }
        
        return (.none, false)
    }

    // MARK: - Private
    
    fileprivate func calculateFramesForLocations() -> [WindowLocation: CGRect] {
        
        guard let screen = screen else { return [:] }
        guard let masterScreen = masterScreen else { return [:] }
        
        var yOffset: CGFloat = 0
        
        if masterScreen != screen {
            yOffset = -((screen.size.height - masterScreen.size.height) + screen.origin.y)
        }
        
        var desiredFrames: [WindowLocation: CGRect] = [:]
        
        desiredFrames[.full] = CGRect(x: screen.minX, y: yOffset, width: screen.width, height: screen.height)
        desiredFrames[.left] = CGRect(x: screen.minX, y: yOffset, width: screen.width / 2, height: screen.height)
        desiredFrames[.right] = CGRect(x: screen.midX, y: yOffset, width: screen.width / 2, height: screen.height)
        desiredFrames[.topLeft] = CGRect(x: screen.minX, y: yOffset, width: screen.width / 2, height: screen.height / 2)
        desiredFrames[.topRight] = CGRect(x: screen.midX, y: yOffset, width: screen.width / 2, height: screen.height / 2)
        desiredFrames[.bottomLeft] = CGRect(x: screen.minX, y: yOffset + (screen.height / 2), width: screen.width / 3, height: screen.height / 2)
        desiredFrames[.bottomMiddle] = CGRect(x: screen.minX + (screen.width / 3), y: yOffset + (screen.height / 2), width: screen.width / 3, height: screen.height / 2)
        desiredFrames[.bottomRight] = CGRect(x: screen.minX + ((screen.width / 3) * 2), y: yOffset + (screen.height / 2), width: screen.width / 3, height: screen.height / 2)
        
        return desiredFrames
    }
    
    fileprivate func frameMatches(_ frame: CGRect, comparison: CGRect, tolerance: CGFloat) -> Bool {
        
        let minFrame = CGRect(x: comparison.minX - tolerance, y: comparison.minY - tolerance, width: comparison.width - tolerance, height: comparison.height - tolerance)
        let maxFrame = CGRect(x: comparison.minX + tolerance, y: comparison.minY + tolerance, width: comparison.width + tolerance, height: comparison.height + tolerance)
        
        let isBigger = frame.origin.x >= minFrame.origin.x && frame.origin.y >= minFrame.origin.y && frame.width >= minFrame.width && frame.height >= minFrame.height
        
        let isSmaller = frame.minX <= maxFrame.minX && frame.minY <= maxFrame.minY && frame.width <= maxFrame.width && frame.height <= maxFrame.height
        
        return isBigger && isSmaller
    }
    
}













































