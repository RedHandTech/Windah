//
//  RHAppleScriptRunner.swift
//  Windah
//
//  Created by Sanders, Robert on 29/07/2016.
//  Copyright © 2016 Red Hand Technologies. All rights reserved.
//

import Foundation

// TODO: Add value replacement functionality

class RHApleScriptRunner {
    
    // MARK: - Public
    
    enum ValueType: UInt32 {
        case list = 1818850164
        case long = 1819242087
        case object = 1868720672
        case unknown = 0
    }
    
    // MARK: - Class Funcs
    
    class func runScript(_ name: String, pathExt: String?) -> (type: ValueType?, value: [NSAppleEventDescriptor])? {
        
        guard let path = Bundle.main.path(forResource: name, ofType: pathExt) else { return nil }
        return runScript(path)
    }
    
    class func runScript(_ path: String) -> (type: ValueType?, value: [NSAppleEventDescriptor])? {
        
        // Load script from file
        guard let script = try? String(contentsOfFile: path) else { return nil }
        return runRawScript(script)
    }
    
    class func runRawScript(_ script: String) -> (type: ValueType?, value: [NSAppleEventDescriptor])? {
        
        guard let appleScript = NSAppleScript(source: script) else { return nil }
        
        var error: NSDictionary?
        let result = appleScript.executeAndReturnError(&error)
        
        if error != nil {
            print("Error. Need to handle.")
            return nil
        }
        
        var eventDescriptors: [NSAppleEventDescriptor] = []
        var type: ValueType? = ValueType.unknown
        
        if ValueType(rawValue: result.descriptorType) == .list {
            // Unpack values
            
            for index in 0...result.numberOfItems {
                guard let desc = result.atIndex(index) else { continue }
                eventDescriptors += [desc]
                type = ValueType(rawValue: desc.descriptorType)
            }
        } else {
            eventDescriptors += [result]
            type = ValueType(rawValue: result.descriptorType)
        }
        
        
        return (type, eventDescriptors)
    }
    
    class func loadScript(_ name: String, pathExt: String?) -> String? {
            
        guard let path = Bundle.main.path(forResource: name, ofType: pathExt) else { return nil }
        return loadScript(path)
    }
    
    class func loadScript(_ path: String) -> String? {
        
        return try? String(contentsOfFile: path)
    }
    
    class func insertValues(_ script: String, replacements: [String: String]) -> String {
        
        let mutableScript = NSMutableString(string: script)
        
        for pair in replacements {
            mutableScript.replaceOccurrences(of: String(format: "^^%@^^", pair.0), with: pair.1, options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, mutableScript.length))
        }
        
        return mutableScript as String
    }
    
}




























