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

class SettingsModel {
    
    weak var view: SettingsViewProtocol?
    
    lazy var xmlDictManager: XMLDictManager = {
        let manager = XMLDictManager()
        return manager
    }()
    
    var storageManager: StorageManagerProtocol?

    init() {}
    
    var words: [Word]? // for populating persistent storage
}


// MARK: - COREDATA BRIDGE
extension SettingsModel {

    func populatePersistentStorage() {
        do {
            try storageManager?.populateStorage(words: words)
        } catch {
            debugPrint(error)
        }
    }
    
    func fetchAndClean() {
        do {
            try storageManager?.fetchAllWordsAndCleanDatabase()
        } catch {
            debugPrint(error)
        }
    }
    
    func fetchWord(_ string: String, completion: @escaping (Result<[Word], Error>)->()) {
        storageManager?.fetchWord(string) { result in
            completion(result)
        }
    }
    
}

// MARK: - XML BRIDGE
extension SettingsModel {
    
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
