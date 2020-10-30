//
//  StorageManager.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 23.10.2020.
//

import Foundation
import UIKit
import CoreData

enum StorageError: Error {
    case dataError
    case pathError
    case emptyArrayError
}

class StorageManager {
    
    var words: [Word]?
    
    var fetchedWords: [Word]?
    
    var xmlDictManager: XMLDictManager?
    
    var coreDataManager: CoreDataManager?
    
}

extension StorageManager {
    
    func storeWordsToPersistentStorage() {
        coreDataManager = CoreDataManager()
        coreDataManager?.storeWordsToPersistentStorage(words: words)
    }
    
    func storeWordToPersistentStorage(word: Word) {
        coreDataManager = CoreDataManager()
        coreDataManager?.storeWordToPersistentStorage(word: word)
    }
    
    func fetchAndClean() {
        coreDataManager = CoreDataManager()
        coreDataManager?.fetchAndClean()
    }
    
    func fetchWord(_ string: String) {
        coreDataManager = CoreDataManager()
        coreDataManager?.fetchWord(string, { words in
            print(words)
        })
    }
    
}

extension StorageManager {
    
    func getWordsFromXMLDict() {
        xmlDictManager = XMLDictManager()
        xmlDictManager?.makeWordsFromXML({ words in
            self.words = words
        })
        //print(self.words?.last ?? "nil")
        print(words?.count ?? "nil")
        print(#function)
    }
    
    func makeNewXMLDictionary() {
        xmlDictManager = XMLDictManager()
        do {
            try xmlDictManager?.makeNewXMLDictionaryFromWords(words)
        } catch {
            print(error)
        }
        print(#function)
    }
}
