//
//  ManagedCard+CoreDataProperties.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 29.11.2020.
//
//

import Foundation
import CoreData


extension ManagedCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedCard> {
        return NSFetchRequest<ManagedCard>(entityName: "ManagedCard")
    }

    @NSManaged public var defaultIndex: Int16
    @NSManaged public var failureCount: Int16
    @NSManaged public var successCount: Int16
    @NSManaged public var values: String
    @NSManaged public var word: String
    @NSManaged public var wordId: UUID
    @NSManaged public var listId: UUID

}

extension ManagedCard : Identifiable {

}
