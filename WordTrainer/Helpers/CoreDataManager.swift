//
//  CoreDataManager.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 29.10.2020.
//

import Foundation
import CoreData

class StorageErrors: Error {
    
}

protocol StaticStorageProtocol {
    func populateStorage(words: [Word]?) throws
    func fetchAllWordsAndCleanDatabase() throws
}

protocol StorageManagerProtocol: class {
    
    func populateStorage(words: [Word]?) throws
    func fetchAllWordsAndCleanDatabase() throws
    
    func fetchWord(_ string: String, _ completion: @escaping (Result<[Word], Error>)->())
   
    func storeNewList(list: List) throws
    func deleteList(_ list: List) throws
    func storeNameForList(name: String, list: List) throws
    func storeIsDefaulsForList(isDefault: Bool, list: List) throws
    
    func storeNewCard(_ card: Card) throws
    func deleteCard(_ card: Card) throws
    func deleteCardsInList(_ list: List) throws
    func storeCardDefaultIndex(_ index: Int, card: Card) throws
    func storeCardSuccess(_ success: Int, card: Card) throws
    func storeCardFailure(_ failure: Int, card: Card) throws
    
    func fetchAllLists(_ completion: @escaping (Result<[List], Error>)->())
    func fetchCardsForList(list: List, _ completion: @escaping (Result<[Card], Error>)->())
    
}


class CoreDataManager {
    lazy var coreDataStack = CoreDataStack(modelName: "WordTrainer")
}

// MARK: - STATIC STORAGE
//extension CoreDataManager: StaticStorageProtocol {
//
//    func populateStorage(words: [Word]?) throws {
//
//        let managedContext = coreDataStack.managedContext
//        let entity = NSEntityDescription.entity(forEntityName: "ManagedWord", in: managedContext)!
//
//        words?.forEach({ word in
//            let managedWord = NSManagedObject(entity: entity, insertInto: managedContext)
//            managedWord.setValue(word.key, forKeyPath: #keyPath(ManagedWord.key))
//            managedWord.setValue(word.word, forKey: #keyPath(ManagedWord.word))
//            let values = convertValuesToString(word.values)
//            managedWord.setValue(values, forKeyPath: #keyPath(ManagedWord.values))
//            managedWord.setValue(word.id, forKeyPath: #keyPath(ManagedWord.wordId))
//        })
//
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            throw error
//            //debugPrint("Could not save. \(error), \(error.userInfo)")
//        }
//    }
//
//    func fetchAllWordsAndCleanDatabase() throws {
//
//        let managedContext = coreDataStack.managedContext
//        let fetchRequest = NSFetchRequest<ManagedWord>(entityName: "ManagedWord")
//        var fetchedWords: [ManagedWord] = []
//
//        do {
//            fetchedWords = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            debugPrint("Could not fetch. \(error), \(error.userInfo)")
//        }
//
//        for word in fetchedWords {
//            managedContext.delete(word)
//        }
//
//        debugPrint(fetchedWords.count)
//
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            throw error
//            //debugPrint("Could not save. \(error), \(error.userInfo)")
//        }
//    }
//}

// MARK: - STORAGE MANAGER
extension CoreDataManager: StorageManagerProtocol {
    
    
    func populateStorage(words: [Word]?) throws {
        let managedContext = coreDataStack.managedContext
        let entity = NSEntityDescription.entity(forEntityName: "ManagedWord", in: managedContext)!
        
        words?.forEach({ word in
            let managedWord = NSManagedObject(entity: entity, insertInto: managedContext)
            managedWord.setValue(word.key, forKeyPath: #keyPath(ManagedWord.key))
            managedWord.setValue(word.word, forKey: #keyPath(ManagedWord.word))
            let values = convertValuesToString(word.values)
            managedWord.setValue(values, forKeyPath: #keyPath(ManagedWord.values))
            managedWord.setValue(word.id, forKeyPath: #keyPath(ManagedWord.wordId))
        })
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            throw error
            //debugPrint("Could not save. \(error), \(error.userInfo)")
        }
        
        managedContext.reset()
    }
    
    func fetchAllWordsAndCleanDatabase() throws {
        let managedContext = coreDataStack.managedContext
        let fetchRequest = NSFetchRequest<ManagedWord>(entityName: "ManagedWord")
        var fetchedWords: [ManagedWord] = []
        
        do {
            fetchedWords = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for word in fetchedWords {
            managedContext.delete(word)
        }
        
        debugPrint(fetchedWords.count)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            throw error
            //debugPrint("Could not save. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
    func fetchWord(_ string: String, _ completion: @escaping (Result<[Word], Error>)->()) {
        let managedContext = coreDataStack.managedContext
        let fetchRequest: NSFetchRequest<ManagedWord> = ManagedWord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K BEGINSWITH %@", argumentArray: [#keyPath(ManagedWord.key), string])
        // CONTAINS, ==
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ManagedWord.key), ascending: true)]
        var fetchedWords: [ManagedWord] = []
        do {
            fetchedWords = try managedContext.fetch(fetchRequest)
            let words = fetchedWords.compactMap { (managedWord) -> Word? in
                return createWordFromManagedWord(managedWord: managedWord)
            }
            completion(.success(words) )
        } catch let error as NSError {
            completion(.failure(error))
            debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
    func deleteCardsInList(_ list: List) throws {
        let managedContext = coreDataStack.managedContext
        let fetchRequest = NSFetchRequest<ManagedCard>(entityName: "ManagedCard")
        fetchRequest.predicate = NSPredicate(format: "listId == %@", list.listId as CVarArg)
        var fetchedCards: [ManagedCard]
        
        do {
            fetchedCards = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            throw error
            //debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
        
        fetchedCards.forEach { managedCard in
            managedContext.delete(managedCard)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            throw error
            //debugPrint("Could not save. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
    
    func storeNewList(list: List) throws {
        let managedContext = coreDataStack.managedContext
        let entity = NSEntityDescription.entity(forEntityName: "ManagedList", in: managedContext)!
        
        let managedList: ManagedList = NSManagedObject(entity: entity, insertInto: managedContext) as! ManagedList
        managedList.setValue(list.name, forKey: #keyPath(ManagedList.name))
        managedList.setValue(list.listId, forKey:  #keyPath(ManagedList.listId))
        managedList.setValue(list.isDefault, forKey: #keyPath(ManagedList.isDefault))
        do {
            try managedContext.save()
        } catch let error as NSError {
            throw error
            //debugPrint("Could not save. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
    func deleteList(_ list: List) throws {
        let managedContext = coreDataStack.managedContext
        let fetchRequest = NSFetchRequest<ManagedList>(entityName: "ManagedList")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(ManagedList.listId), list.listId])
        let fetchedLists: [ManagedList]
        do {
            fetchedLists = try managedContext.fetch(fetchRequest)
            //print(fetchedLists)
        } catch let error as NSError {
            throw error
            //debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if let list = fetchedLists.first {
            //print(list)
            managedContext.delete(list)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            throw error
            //debugPrint("Could not save. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
    func storeNameForList(name: String, list: List) throws {
        let managedContext = coreDataStack.managedContext
        let fetchRequest = NSFetchRequest<ManagedList>(entityName: "ManagedList")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(ManagedList.listId), list.listId])
        var fetchedList: ManagedList
        do {
            fetchedList = try managedContext.fetch(fetchRequest).first!
        } catch let error as NSError {
            throw error
            //debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
        
        fetchedList.setValue(name, forKey: #keyPath(ManagedList.name))
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            throw error
            //debugPrint("Could not save. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
    func storeIsDefaulsForList(isDefault: Bool, list: List) throws {
        let managedContext = coreDataStack.managedContext
        let fetchRequest = NSFetchRequest<ManagedList>(entityName: "ManagedList")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(ManagedList.listId), list.listId])
        var fetchedList: ManagedList
        
        do {
            fetchedList = try managedContext.fetch(fetchRequest).first!
        } catch let error as NSError {
            throw error
            //debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
        
        fetchedList.setValue(isDefault, forKey: #keyPath(ManagedList.isDefault))
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            throw error
            //debugPrint("Could not save. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
    func storeNewCard(_ card: Card) throws {
        let managedContext = coreDataStack.managedContext
        let entity = NSEntityDescription.entity(forEntityName: "ManagedCard", in: managedContext)!
        
        let values = convertValuesToString(card.values)
        
        let managedCard: ManagedCard = NSManagedObject(entity: entity, insertInto: managedContext) as! ManagedCard
        managedCard.setValue(card.word, forKey: #keyPath(ManagedCard.word))
        managedCard.setValue(values, forKey: #keyPath(ManagedCard.values))
        managedCard.setValue(card.listId, forKey: #keyPath(ManagedCard.listId))
        managedCard.setValue(card.wordId, forKey: #keyPath(ManagedCard.wordId))
        managedCard.setValue(card.defaultIndex, forKey: #keyPath(ManagedCard.defaultIndex))
        managedCard.setValue(card.successCount, forKey: #keyPath(ManagedCard.successCount))
        managedCard.setValue(card.failureCount, forKey: #keyPath(ManagedCard.failureCount))
        do {
            try managedContext.save()
        } catch let error as NSError {
            throw error
            //debugPrint("Could not save. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
    func deleteCard(_ card: Card) throws {
        let managedContext = coreDataStack.managedContext
        let fetchRequest = NSFetchRequest<ManagedCard>(entityName: "ManagedCard")
        fetchRequest.predicate = NSPredicate(format: "listId == %@ && wordId == %@", card.listId as CVarArg, card.wordId as CVarArg)
        var fetchedCard: ManagedCard
        
        do {
            fetchedCard = try managedContext.fetch(fetchRequest).first!
        } catch let error as NSError {
            throw error
            //debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
        
        managedContext.delete(fetchedCard)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            throw error
            //debugPrint("Could not save. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
    func storeCardDefaultIndex(_ index: Int, card: Card) throws {
        let managedContext = coreDataStack.managedContext
        let fetchRequest = NSFetchRequest<ManagedCard>(entityName: "ManagedCard")
        fetchRequest.predicate = NSPredicate(format: "listId == %@ && wordId == %@", card.listId as CVarArg, card.wordId as CVarArg)
        var fetchedCard: ManagedCard
        
        do {
            fetchedCard = try managedContext.fetch(fetchRequest).first!
        } catch let error as NSError {
            throw error
            //debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
        
        fetchedCard.setValue(index, forKey: #keyPath(ManagedCard.defaultIndex))
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            throw error
            //debugPrint("Could not save. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
    func storeCardSuccess(_ success: Int, card: Card) throws {
        let managedContext = coreDataStack.managedContext
        let fetchRequest = NSFetchRequest<ManagedCard>(entityName: "ManagedCard")
        fetchRequest.predicate = NSPredicate(format: "listId == %@ && wordId == %@", card.listId as CVarArg, card.wordId as CVarArg)
        var fetchedCard: ManagedCard
        
        do {
            fetchedCard = try managedContext.fetch(fetchRequest).first!
        } catch let error as NSError {
            throw error
            //debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
        
        fetchedCard.setValue(success, forKey: #keyPath(ManagedCard.successCount))
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            throw error
            //debugPrint("Could not save. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
    func storeCardFailure(_ failure: Int, card: Card) throws {
        let managedContext = coreDataStack.managedContext
        let fetchRequest = NSFetchRequest<ManagedCard>(entityName: "ManagedCard")
        fetchRequest.predicate = NSPredicate(format: "listId == %@ && wordId == %@", card.listId as CVarArg, card.wordId as CVarArg)
        var fetchedCard: ManagedCard
        
        do {
            fetchedCard = try managedContext.fetch(fetchRequest).first!
        } catch let error as NSError {
            throw error
            //debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
        
        fetchedCard.setValue(failure, forKey: #keyPath(ManagedCard.failureCount))
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            throw error
            //debugPrint("Could not save. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
    func fetchAllLists(_ completion: @escaping (Result<[List], Error>) -> ()) {
        let managedContext = coreDataStack.managedContext
        let fetchRequest: NSFetchRequest<ManagedList> = ManagedList.fetchRequest()
        //fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(ManagedList.name), name])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ManagedList.name), ascending: true)]
        do {
            let fetchedLists: [ManagedList] = try managedContext.fetch(fetchRequest)
            let lists = fetchedLists.map { (managedList) -> List in
                createListFromManagedList(managedList: managedList)
            }
            completion(.success(lists))
        } catch let error as NSError {
            completion(.failure(error))
            debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
    func fetchCardsForList(list: List, _ completion: @escaping (Result<[Card], Error>) -> ()) {
        let managedContext = coreDataStack.managedContext
        let fetchRequest: NSFetchRequest<ManagedCard> = ManagedCard.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(ManagedCard.listId), list.listId])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ManagedCard.word), ascending: true)]
        do {
            let fetchedCards = try managedContext.fetch(fetchRequest)
            let cards = fetchedCards.map { (managedCard) -> Card in
                createCardFromManagedCard(managedCard: managedCard)
            }
            completion(.success(cards))
        } catch let error as NSError {
            completion(.failure(error))
            debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
        managedContext.reset()
    }
    
}

// MARK: - HELPERS
extension CoreDataManager {
    
    private func createWordFromManagedWord(managedWord: ManagedWord) -> Word {
        let values = convertStringToValues(managedWord.values)
        return Word(key: managedWord.key, id: managedWord.wordId, word: managedWord.word ?? "", values: values)
    }
    
    private func createCardFromManagedCard(managedCard: ManagedCard) -> Card {
        let values = convertStringToValues(managedCard.values)
        return Card(word: managedCard.word, wordId: managedCard.wordId, listId: managedCard.listId, values: values, defaultIndex: Int(managedCard.defaultIndex), successCount: Int(managedCard.successCount), failureCount: Int(managedCard.failureCount))
    }
    
    private func createListFromManagedList(managedList: ManagedList) -> List {
        return List(name: managedList.name, listId: managedList.listId, isDefault: managedList.isDefault)
    }
    
    private func convertValuesToString(_ values: [String]) -> String {
        let separator = "\n"
        return values.joined(separator: separator)
    }
    
    private func convertStringToValues(_ string: String) -> [String] {
        let separator = "\n"
        return string.components(separatedBy: separator)
    }
    
}


//func fetchAllWordsAndCleanDatabase() {
    
//        let managedContext = coreDataStack.managedContext
//
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ManagedWord.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        deleteRequest.resultType = .resultTypeObjectIDs
//
//        do {
//            let result = try managedContext.execute(
//                deleteRequest, with: managedContext
//            )
//
//            guard
//                let deleteResult = result as? NSBatchDeleteResult,
//                let ids = deleteResult.result as? [NSManagedObjectID]
//            else { return }
//
//            let changes = [NSDeletedObjectsKey: ids]
//            NSManagedObjectContext.mergeChanges(
//                fromRemoteContextSave: changes,
//                into: [managedContext]
//            )
//        } catch {
//            print(error as Any)
//        }
//}
