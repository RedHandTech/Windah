//
//  RHIconActionHandler.swift
//  Windah
//
//  Created by Sanders, Robert on 28/07/2016.
//  Copyright © 2016 Red Hand Technologies. All rights reserved.
//

import Cocoa

class RHIconActionHandler: NSObject {
    
    // MARK: - Private
    
    var optionWindow: NSWindow?
    
    // MARK: - Public
    
    @objc func iconWasClicked(_ sender: NSStatusBarButton) { }
    
    func setupMenu(_ item: NSStatusItem) {
        item.menu = NSMenu(title: "Menu")
        
        let optionItem = NSMenuItem()
        optionItem.title = "Settings"
        optionItem.target = self
        optionItem.action = #selector(optionPanel)
        
        item.menu?.addItem(optionItem)
        
        let quitItem = NSMenuItem()
        quitItem.title = "Quit"
        quitItem.target = self
        quitItem.action = #selector(quitClicked)
        
        item.menu?.addItem(quitItem)
    }
    
    // MARK: - Actions
    
    @objc func quitClicked(sender: NSMenuItem) {
        NSApp.terminate(self)
    }
    
    @objc func optionPanel(sender: NSMenuItem) {
        let storyboard = NSStoryboard(name: "OptionPanel", bundle: nil)
        guard let windowController = storyboard.instantiateController(withIdentifier: "OptionWindowController") as? NSWindowController else { return }
        
        // note: should the window be released when closed?
        optionWindow = windowController.window
        optionWindow?.makeKeyAndOrderFront(nil)
    }
    
}














