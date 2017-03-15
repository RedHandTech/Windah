//
//  AppDelegate.swift
//  Windah
//
//  Created by Sanders, Robert on 28/07/2016.
//  Copyright © 2016 Red Hand Technologies. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    var statusItem: NSStatusItem?
    
    var actionHandler: RHIconActionHandler?
    var keyCaptureHandler: RHKeyCaptureHandler?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Setup handlers
        
        actionHandler = RHIconActionHandler()
        keyCaptureHandler = RHKeyCaptureHandler()
        
        // Setup icon
        
        statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        
        if let icon = NSImage(named: "icon") {
            icon.size = NSMakeSize(20, 20)
            statusItem?.image = icon
        }
        
        statusItem?.target = actionHandler
        statusItem?.action = #selector(RHIconActionHandler.iconWasClicked(_:))
        
        actionHandler?.setupMenu(statusItem!)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }


}











