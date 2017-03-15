//
//  Math_Spec.swift
//  Windah
//
//  Created by Robert Sanders on 14/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

import XCTest

class Math_Spec: XCTestCase {

    func test_min() {
        XCTAssertEqual(min(2, 3), 2)
    }
    
    func test_max() {
        XCTAssertEqual(max(2, 3), 3)
    }
    
    func test_clamp() {
        
        XCTAssertEqual(clamp(val: 10, lowerBound: 3, upperBound: 7), 7)
        
        XCTAssertEqual(clamp(val: 10, lowerBound: 11, upperBound: 20), 11)
        
        XCTAssertEqual(clamp(val: 10, lowerBound: 8, upperBound: 20), 10)
    }

}
