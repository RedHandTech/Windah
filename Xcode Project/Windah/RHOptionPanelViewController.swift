//
//  RHOptionPanelViewController.swift
//  Windah
//
//  Created by Robert Sanders on 14/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

import Cocoa

class RHOptionPanelViewController: NSViewController {
    
    // MARK: - Outlets
    
    // MARK: - Private
    
    fileprivate let viewModel: RHOptionPanelViewModel = RHOptionPanelViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.7).cgColor
        view.layer?.cornerRadius = 10
    }
    
}
