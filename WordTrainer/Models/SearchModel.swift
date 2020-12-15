//
//  SearchModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import Foundation



protocol CardCheckingProtocol: class {
    func checkCard(_ card: Card) -> Bool
}

class SearchModel {
    
    weak var view: SearchViewProtocol?
    
    var storageManager: StorageManagerProtocol
    
    init(currentList: List, storageManager: StorageManagerProtocol) {
        self.currentList = currentList
        self.storageManager = storageManager
    }
    
    var fetchedWords: [Word] = [] // for search and creating card
    var currentList: List // for fetching of cards
    
    
    func searchWordInPersistentStorage(word: String) {
        storageManager.fetchWord(word) { (result) in
            do {
                let words = try result.get()
                self.fetchedWords = words
                self.view?.needsReload()
            } catch {
                self.fetchedWords = []
                self.view?.needsReload()
            }
        }
    }
    
    func makeCardFromFetchedWordWithIndex(_ index: Int, for list: List) -> Card {
        let word = fetchedWords[index]
        let card = Card(word: word.word, wordId: word.id, listId: list.listId, values: word.values)
        return card
    }
    
}
