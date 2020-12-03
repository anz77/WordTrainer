//
//  StringToDataTransformer.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 02.11.2020.
//

import Foundation

@objc(StringToDataTransformer)
class StringToDataTransformer: ValueTransformer {
    
    
    override func transformedValue(_ value: Any?) -> Any? {
        let boxedData = try! NSKeyedArchiver.archivedData(withRootObject: value!, requiringSecureCoding: false)
        return boxedData
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        let typedBlob = value as! Data
        let data = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: NSString.self, from: typedBlob)//unarchivedObject(ofClasses: [NSString.self], from: typedBlob)
        if let data = data {
            return (data as [String])
        }
        return nil
        
    }
    
}
