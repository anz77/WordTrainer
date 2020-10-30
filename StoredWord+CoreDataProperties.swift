//
//  StoredWord+CoreDataProperties.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 29.10.2020.
//
//

import Foundation
import CoreData


extension StoredWord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredWord> {
        return NSFetchRequest<StoredWord>(entityName: "StoredWord")
    }

    @NSManaged public var k: String?
    @NSManaged public var value: String?

}

extension StoredWord : Identifiable {

}
