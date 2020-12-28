//
//  ManagedList+CoreDataProperties.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 29.11.2020.
//
//

import Foundation
import CoreData


extension ManagedList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedList> {
        return NSFetchRequest<ManagedList>(entityName: "ManagedList")
    }

    @NSManaged public var listId: UUID
    @NSManaged public var name: String

}

extension ManagedList : Identifiable {

}
