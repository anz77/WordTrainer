//
//  PreferencesModel.swift
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

class PreferensesModel {
    
    weak var view: PreferensesViewProtocol?
    
    lazy var xmlDictManager: XMLDictManager = {
        let manager = XMLDictManager()
        return manager
    }()
    
    var storageManager: StorageManagerProtocol

    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }
    
    var words: [Word]? // for populating persistent storage
}


// MARK: - COREDATA BRIDGE
extension PreferensesModel {

    
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
extension PreferensesModel {
    
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
