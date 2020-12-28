//
//  SearchModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import Foundation

protocol SearchModelProtocol: class {
    var viewNeedsReload: (()->())? {get set}
    func configureItemWithIndex(_ index: Int, completion: @escaping (Word)->())
    
    func fetchedWordsCount() -> Int
    func fetchedWordWithIndex(_ index: Int) -> Word
    func currentList() -> List
    func searchWordInPersistentStorage(word: String)
    func makeCardFromFetchedWordWithIndex(_ index: Int, for list: List) -> Card
}

protocol CardCheckingProtocol: class {
    func checkCard(_ card: Card) -> Bool
}

class SearchModel {
    
    var viewNeedsReload: (()->())?
    var storageManager: StorageManagerProtocol?
    
    private var fetchedWords: [Word] = []
    private var list: List
    
    init(list: List) {
        self.list = list
    }
}


extension SearchModel: SearchModelProtocol {
    
    func configureItemWithIndex(_ index: Int, completion: @escaping (Word)->()) {
        completion(fetchedWords[index])
    }
    
    func fetchedWordsCount() -> Int {
        fetchedWords.count
    }
    
    func fetchedWordWithIndex(_ index: Int) -> Word {
        fetchedWords[index]
    }
    
    func currentList() -> List {
        list
    }
    
    func searchWordInPersistentStorage(word: String) {
        storageManager?.fetchWord(word) { (result) in
            do {
                let words = try result.get()
                self.fetchedWords = words
                self.viewNeedsReload?()
            } catch {
                self.fetchedWords = []
                self.viewNeedsReload?()
                debugPrint(error)
            }
        }
    }
    
    func makeCardFromFetchedWordWithIndex(_ index: Int, for list: List) -> Card {
        let word = fetchedWords[index]
        let card = Card(word: word.word, wordId: word.id, listId: list.listId, values: word.values)
        return card
    }
    
}
