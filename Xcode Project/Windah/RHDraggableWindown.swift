//
//  RHDraggableWindown.swift
//  Windah
//
//  Created by Robert Sanders on 14/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

import Cocoa

class RHDraggableWindow: NSWindow {
    
    // MARK: - Private
    
    fileprivate var dragOffset: NSPoint = NSZeroPoint
    
    // MARK: - Event Tracking
    
    override func mouseDown(with event: NSEvent) {
        
        let bounds = convertFromScreen(frame)
        let loc = event.locationInWindow
        
        dragOffset.x = bounds.origin.x - loc.x
        dragOffset.y = bounds.origin.y - loc.y
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        var bounds = convertFromScreen(frame)
        let loc = event.locationInWindow
        
        bounds.origin.x = loc.x + dragOffset.x
        bounds.origin.y = loc.y + dragOffset.y
        
        bounds = convertToScreen(bounds)
        
        setFrame(bounds, display: true)
    }
    
}










