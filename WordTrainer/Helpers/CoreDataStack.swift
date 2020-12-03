//
//  CoreDataStack.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.10.2020.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
//    lazy var coordinator: NSPersistentStoreCoordinator = {
//        return self.storeContainer.persistentStoreCoordinator
//    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
//    private lazy var storeContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: self.modelName)
//        container.loadPersistentStores { (storeDescription, error) in
//            if let error = error as NSError? {
//                debugPrint("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//        return container
//    }()
    
    private lazy var storeContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: self.modelName)
        let defaultDirectoryURL = NSPersistentContainer.defaultDirectoryURL()
        
        let staticStoreURL = defaultDirectoryURL.appendingPathComponent("Static.sqlite")
        let staticStoreDescription = NSPersistentStoreDescription(url: staticStoreURL)
        staticStoreDescription.configuration = "Static"

        let dynamicStoreURL = defaultDirectoryURL.appendingPathComponent("Dynamic.sqlite")
        let dynamicStoreDescription = NSPersistentStoreDescription(url: dynamicStoreURL)
        dynamicStoreDescription.configuration = "Dynamic"

        container.persistentStoreDescriptions = [staticStoreDescription, dynamicStoreDescription]
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("###\(#function): Failed to load persistent stores:\(error)")
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        //generateSampleDataIfNeeded(context: container.newBackgroundContext())

        return container
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            debugPrint("Unresolved error \(error), \(error.localizedDescription)")
        }
    }
}
