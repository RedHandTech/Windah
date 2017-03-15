//
//  RHKeyCaptureHandler.swift
//  Windah
//
//  Created by Sanders, Robert on 28/07/2016.
//  Copyright © 2016 Red Hand Technologies. All rights reserved.
//

import Cocoa

// TODO: Make error print statements dialogs using an apple script
// TODO: Make key bindings customisabled

enum Key: UInt16 {
    case down = 125
    case up = 126
    case left = 123
    case right = 124
}

class RHKeyCaptureHandler: NSObject {
    
    // MARK: - Private
    
    fileprivate let triggerKeys: NSEventModifierFlags = [.control, .option, .command]
    fileprivate let secondaryTriggerKeys: NSEventModifierFlags = [.option, .command]
    fileprivate let screenChangeTriggerKeys: NSEventModifierFlags = [.control, .command]
    
    fileprivate var currentTriggerType: TriggerType = .none
    
    fileprivate var eventFlagHandler: AnyObject?
    fileprivate var keyDownHandler: AnyObject?
    
    fileprivate var masterScreenRect: CGRect = CGRect.zero
    
    // MARK: - Public
    
    override init() {
        
        super.init()
        
        setupGlobalEventCapture()
    }
    
    // MARK: - Private
    
    fileprivate func setupGlobalEventCapture() {
        // Check trusted
        let opts = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: kCFBooleanTrue] as CFDictionary
        let trusted = AXIsProcessTrustedWithOptions(opts)
        if trusted {
            
            weak var welf = self
            
            keyDownHandler = NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: { event in
                guard let triggerType = welf?.currentTriggerType else { return }
                guard let key = Key(rawValue: event.keyCode) else { return }
                
                switch key {
                case .up:
                    switch triggerType {
                    case .primary:
                        welf?.makeWindowFullscreen()
                        break
                    case .secondary:
                        welf?.secondaryTriggerHit(key)
                        break
                    case .screenChange:
                        welf?.swapScreens(key)
                        break
                    default:
                        break
                    }
                    break
                case .down:
                    switch triggerType {
                    case .primary:
                        welf?.makeWindowMinimise()
                        break
                    case .secondary:
                        welf?.secondaryTriggerHit(key)
                        break
                    case .screenChange:
                        welf?.swapScreens(key)
                        break
                    default:
                        break
                    }
                    break
                case .left:
                    switch triggerType {
                    case .primary:
                        welf?.makeWindowLeft()
                        break
                    case .secondary:
                        welf?.secondaryTriggerHit(key)
                        break
                    case .screenChange:
                        welf?.swapScreens(key)
                        break
                    default:
                        break
                    }
                    break
                case .right:
                    switch triggerType {
                    case .primary:
                        welf?.makeWindowRight()
                        break
                    case .secondary:
                        welf?.secondaryTriggerHit(key)
                        break
                    case .screenChange:
                        welf?.swapScreens(key)
                        break
                    default:
                        break
                    }
                    break
                }
            }) as AnyObject?
            
            eventFlagHandler = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged, handler: { event in
                
                guard let welf = welf else { return }
                
                if welf.triggerKeys.rawValue & event.modifierFlags.rawValue == welf.triggerKeys.rawValue {
                    welf.currentTriggerType = .primary
                } else if welf.secondaryTriggerKeys.rawValue & event.modifierFlags.rawValue == welf.secondaryTriggerKeys.rawValue {
                    welf.currentTriggerType = .secondary
                } else if welf.screenChangeTriggerKeys.rawValue & event.modifierFlags.rawValue == welf.screenChangeTriggerKeys.rawValue {
                    welf.currentTriggerType = .screenChange
                } else {
                    welf.currentTriggerType = .none
                }
            }) as AnyObject?
        }
    }
    
    // MARK: - Window Controlling Functions
    
    fileprivate func makeWindowFullscreen() {
        
        guard let screenAndWindow = matchScreenToWindow() else {
            // TODO: Present error here
            return
        }
        
        let screen = screenAndWindow.screen
        
        // Set position
        guard let desiredFrame = RHWindowLocationDetector.retrievePossibleWindowFrames(screen.visibleFrame, mainScreenFrame: masterScreenRect)[.full] else { return }
        
        positionWindow(desiredFrame)
    }
    
    fileprivate func makeWindowMinimise() {
        
        // Run hide script
        // Kinda annoying
        //RHApleScriptRunner.runScript("hide_window", pathExt: "txt")
    }
    
    fileprivate func makeWindowLeft() {
        
        guard let screenAndWindow = matchScreenToWindow() else {
            // TODO: Present error here
            return
        }
        
        let screen = screenAndWindow.screen
        
        // Set position
        guard let desiredFrame = RHWindowLocationDetector.retrievePossibleWindowFrames(screen.visibleFrame, mainScreenFrame: masterScreenRect)[.left] else { return }
        
        positionWindow(desiredFrame)
    }
    
    fileprivate func makeWindowRight() {
        
        guard let screenAndWindow = matchScreenToWindow() else {
            // TODO: Present error here
            return
        }
        
        let screen = screenAndWindow.screen
        
        // Set position
        guard let desiredFrame = RHWindowLocationDetector.retrievePossibleWindowFrames(screen.visibleFrame, mainScreenFrame: masterScreenRect)[.right] else { return }
        
        positionWindow(desiredFrame)
    }
    
    fileprivate func secondaryTriggerHit(_ arrowDirection: Key) {
        
        guard let screenAndWindow = matchScreenToWindow() else {
            // TODO: Present error here
            return
        }
        
        let screen = screenAndWindow.screen
        let windowFrame = screenAndWindow.windowBounds
        
        let detector = RHWindowLocationDetector(windowFrame: windowFrame, screenFrame: screen.visibleFrame, masterScreenFrame: masterScreenRect)
        
        let windowState = RHWindowState(location: detector.windowLocation)
        
        let nextLocation: WindowLocation = windowState.transition(.secondary, arrowDirection: arrowDirection)
        
        guard let desiredFrame = detector.possibleWindowFrames[nextLocation] else { return }
        positionWindow(desiredFrame)
    }
    
    fileprivate func swapScreens(_ direction: Key) {
        
        guard let screenAndWindow = matchScreenToWindow() else {
            // TODO: Present error here
            return
        }
        
        // Get next screen
        guard let nextScreen = locateScreenInDirection(screenAndWindow.screen, direction: direction) else { return }
        
        // Get current window location
        let currentPosition = RHWindowLocationDetector(windowFrame: screenAndWindow.windowBounds, screenFrame: screenAndWindow.screen.visibleFrame, masterScreenFrame: masterScreenRect).windowLocation
        
        guard let nextPosition = RHWindowLocationDetector.retrievePossibleWindowFrames(nextScreen.visibleFrame, mainScreenFrame: masterScreenRect)[currentPosition != .none ? currentPosition : .full] else { return }
        
        positionWindow(nextPosition)
    }
    
    fileprivate func matchScreenToWindow() -> (screen: NSScreen, windowBounds: CGRect)? {
        
        // Get bounds of main window
        guard let bounds = RHApleScriptRunner.runScript("get_window_bounds", pathExt: "txt") else { return nil }
        
        guard let type = bounds.type else { return nil }
        
        var frame: CGRect = CGRect.zero
        
        switch type {
        case .long:
            
            if bounds.value.count != 4 {
                print("Expecting 4 values got: \(bounds.value.count)")
                return nil
            }
            
            for (index, desc) in bounds.value.enumerated() {
                switch index {
                case 0:
                    frame.origin.x = CGFloat(desc.doubleValue)
                    continue
                case 1:
                    frame.origin.y = CGFloat(desc.doubleValue)
                    continue
                case 2:
                    frame.size.width = CGFloat(desc.doubleValue)
                    continue
                case 3:
                    frame.size.height = CGFloat(desc.doubleValue)
                    continue
                default:
                    break
                }
            }
            
            if frame == CGRect.zero {
                return nil
            }
            
            break
        default:
            print("Expecting type long. Got: \(type)")
            return nil
        }
        
        guard let screens = NSScreen.screens() else { return nil }
        
        for screen in screens {
            
            if screen.frame.origin == CGPoint.zero {
                // Is master screen
                masterScreenRect = screen.frame
            }
            
            // Match X value +  half of window size
            let x = frame.origin.x + (frame.size.width / 2)
            
            if x >= screen.visibleFrame.origin.x && x <= screen.visibleFrame.origin.x + screen.visibleFrame.width {
                return (screen, frame)
            }
        }
 
        return nil
    }
    
    fileprivate func locateScreenInDirection(_ screen: NSScreen, direction: Key) -> NSScreen? {
        
        if direction == .up || direction == .down {
            // Does not currently support up and down just cycles through screens based on X value
            return nil
        }
        
        // Organise screens in order of X
        guard let orderedScreens = NSScreen.screens()?.sorted(by: { $0.visibleFrame.origin.x < $1.visibleFrame.origin.x }) else { return nil }
        var currentIndex: Int = -1
        for (index, s) in orderedScreens.enumerated() {
            if s.visibleFrame == screen.visibleFrame {
                currentIndex = index
            }
        }
        
        if currentIndex == -1 {
            // Screen not found
            return nil
        }
        
        switch direction {
        case .left:
            currentIndex -= 1
            break
        case .right:
            currentIndex += 1
            break
        default:
            // Should never happen
            return nil
        }
        
        if currentIndex < 0 || currentIndex >= orderedScreens.count {
            // Index error cannot proceed
            return nil
        }
        
        return orderedScreens[currentIndex]
    }
    
    fileprivate func positionWindow(_ frame: CGRect) {
        
        let positionVar = "{\(frame.minX), \(frame.minY)}"
        
        guard var positionScript = RHApleScriptRunner.loadScript("set_window_position", pathExt: "txt") else { return }
        positionScript = RHApleScriptRunner.insertValues(positionScript, replacements: ["position": positionVar])
        
        let _ = RHApleScriptRunner.runRawScript(positionScript)
        
        // Set size
        
        let sizeVar = "{\(frame.width), \(frame.height)}"
        
        guard var sizeScript = RHApleScriptRunner.loadScript("set_window_size", pathExt: "txt") else { return }
        sizeScript = RHApleScriptRunner.insertValues(sizeScript, replacements: ["size": sizeVar])
        
        let _ = RHApleScriptRunner.runRawScript(sizeScript)
    }
    
    
    
    
    
   
    
}

























