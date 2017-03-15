//
//  RHWindowLocationDetector_Spec.swift
//  Windah
//
//  Created by Sanders, Robert on 03/08/2016.
//  Copyright © 2016 Red Hand Technologies. All rights reserved.
//

import XCTest

class RHWindowLocationDetector_Spec: XCTestCase {
    

    func testGetFrames() {
        
        let detector = RHWindowLocationDetector(windowFrame: CGRect.zero, screenFrame: CGRect(x: 0, y: 0, width: 1024, height: 768), masterScreenFrame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        let possibleFrames = detector.possibleWindowFrames
        
        XCTAssert(possibleFrames.count == 8)
        XCTAssert(possibleFrames[.full] == CGRect(x: 0, y: 0, width: 1024, height: 768))
        XCTAssert(possibleFrames[.left]?.width == 512)
    }
    
    func testGetWindowLocation() {
        
        let screenRect = CGRect(x: 0, y: 0, width: 1024, height: 768)
        
        let location1 = RHWindowLocationDetector.analyzeWindowPosition(CGRect(x: 0, y: 0, width: 1024, height: 768), screenFrame: screenRect, mainScreenFrame: screenRect)
        XCTAssert(location1 == .full)
        
        let location2 = RHWindowLocationDetector.analyzeWindowPosition(CGRect(x: 0, y: 0, width: 512, height: 768), screenFrame: screenRect, mainScreenFrame: screenRect)
        XCTAssert(location2 == .left)
        
        let location3 = RHWindowLocationDetector.analyzeWindowPosition(CGRect(x: 0, y: 0, width: 1020, height: 700), screenFrame: screenRect, mainScreenFrame: screenRect)
        XCTAssert(location3 == .none)
    }

}
