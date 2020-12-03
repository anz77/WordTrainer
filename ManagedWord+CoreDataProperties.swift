//
//  ManagedWord+CoreDataProperties.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 29.11.2020.
//
//

import Foundation
import CoreData


extension ManagedWord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedWord> {
        return NSFetchRequest<ManagedWord>(entityName: "ManagedWord")
    }

    @NSManaged public var wordId: UUID
    @NSManaged public var key: String
    @NSManaged public var values: String
    @NSManaged public var word: String?

}

extension ManagedWord : Identifiable {

}
