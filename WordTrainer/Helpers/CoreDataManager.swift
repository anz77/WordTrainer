//
//  CoreDataManager.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 29.10.2020.
//

import Foundation
import UIKit
import CoreData


class CoreDataManager {
    
    func storeWordsToPersistentStorage(words: [Word]?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "StoredWord", in: managedContext)!
        _ = words?.map({ word -> () in
            let managedWord = NSManagedObject(entity: entity, insertInto: managedContext)
            managedWord.setValue(word.key, forKeyPath: "k")
            
            let value = convertValuesToString(word.values)
            managedWord.setValue(value, forKeyPath: "value")
        })
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func storeWordToPersistentStorage(word: Word) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "StoredWord", in: managedContext)!
        
        let managedWord = NSManagedObject(entity: entity, insertInto: managedContext)
        managedWord.setValue(word.key, forKeyPath: "k")
        
        let value = convertValuesToString(word.values)
        managedWord.setValue(value, forKeyPath: "value")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchAndClean() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<StoredWord>(entityName: "StoredWord")
        var fetchedWords: [StoredWord] = []
        do {
            fetchedWords = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print(fetchedWords.count)
        for word in fetchedWords {
            managedContext.delete(word)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchWord(_ string: String, _ completion: @escaping ([Word])->()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<StoredWord> = StoredWord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(StoredWord.k), string])
        var fetchedWords: [StoredWord] = []
        do {
            fetchedWords = try managedContext.fetch(fetchRequest)
            
            let words = fetchedWords.compactMap { (storedWord) -> Word? in
                guard let key = storedWord.k, let value = storedWord.value else {
                    return nil
                }
                let values = convertStringToValues(value)
                return Word(key: key, values: values)
            }
            completion(words)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
}

extension CoreDataManager {
    
    func convertValuesToString(_ values: [String]) -> String {
        let separator = "\n"
        return values.joined(separator: separator)
    }
    
    func convertStringToValues(_ string: String) -> [String] {
        let separator = "\n"
        return string.components(separatedBy: separator)
    }
}
