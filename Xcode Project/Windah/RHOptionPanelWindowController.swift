//
//  RHOptionPanelWindowController.swift
//  Windah
//
//  Created by Robert Sanders on 14/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

import Cocoa

class RHOptionPanelWindowController: NSWindowController {
    
    // MARK: - Lifecycle
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.isOpaque = false
        window?.backgroundColor = NSColor.clear
    }
    
}
