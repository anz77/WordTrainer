//
//  TestCoreDataStack.swift
//  WordTrainerTests
//
//  Created by ANDRII ZUIOK on 17.12.2020.
//

@testable import WordTrainer
import Foundation
import CoreData

class TestCoreDataStack: CoreDataStack {
        
    override init(modelName: String) {
        super.init(modelName: modelName)
        
        let container = NSPersistentContainer(name: self.modelName)
        let defaultDirectoryURL = NSPersistentContainer.defaultDirectoryURL()
        
        let staticStoreURL = defaultDirectoryURL.appendingPathComponent("Static.sqlite")
        let staticStoreDescription = NSPersistentStoreDescription(url: staticStoreURL)
        staticStoreDescription.type = NSInMemoryStoreType
        staticStoreDescription.configuration = "Static"

        let dynamicStoreURL = defaultDirectoryURL.appendingPathComponent("Dynamic.sqlite")
        let dynamicStoreDescription = NSPersistentStoreDescription(url: dynamicStoreURL)
        dynamicStoreDescription.type = NSInMemoryStoreType
        dynamicStoreDescription.configuration = "Dynamic"

        container.persistentStoreDescriptions = [staticStoreDescription, dynamicStoreDescription]
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("###\(#function): Failed to load persistent stores:\(error)")
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        //generateSampleDataIfNeeded(context: container.newBackgroundContext())

        
        self.storeContainer = container
    }
    
}
