//
//  Model.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 24.10.2020.
//

import Foundation

enum StorageError: Error {
    case dataError
    case pathError
    case emptyArrayError
}

class Model {
    
    lazy var xmlDictManager: XMLDictManager = {
        let manager = XMLDictManager()
        return manager
    }()
    
    lazy var storageManager: CoreDataManager = {
        let manager = CoreDataManager()
        return manager
    }()
    
    var words: [Word]? // for populating persistent storage
}


// MARK: - COREDATA BRIDGE
extension Model {

    
    func populatePersistentStorage() {
        do {
            try storageManager.populateStorage(words: words)
        } catch {}
    }
    
    func fetchAndClean() {
        do {
            try storageManager.fetchAllWordsAndCleanDatabase()
        } catch {}
    }
    
    func fetchWord(_ string: String, completion: @escaping (Result<[Word], Error>)->()) {
        storageManager.fetchWord(string) { result in
            completion(result)
        }
    }
    
}

// MARK: - XML BRIDGE
extension Model {
    
    func getWordsFromXMLDict() {
        xmlDictManager.makeWordsFromXML({ result in
            DispatchQueue.main.async {
                do {
                    self.words = try result.get()
                    debugPrint(self.words?.count ?? "nil")
                } catch {
                    debugPrint(error)
                }
                debugPrint(#function)
            }
        })
    }
    
    func makeNewXMLDictionary() {
        do {
            try xmlDictManager.makeNewXMLDictionaryFromWords(words)
        } catch {
            debugPrint(error)
        }
        debugPrint(#function)
    }
}
