//
//  Math.swift
//  Windah
//
//  Created by Robert Sanders on 14/01/2017.
//  Copyright © 2017 Red Hand Technologies. All rights reserved.
//

func min<T: Comparable>(a: T, b: T) -> T {
    return a < b ? a : b
}

func max<T: Comparable>(a: T, b: T) -> T {
    return a > b ? a : b
}

func clamp<T: Comparable>(val: T, lowerBound: T, upperBound: T) -> T {
    return max(lowerBound, min(val, upperBound))
}
