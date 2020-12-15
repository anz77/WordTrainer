//
//  ListModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import Foundation

protocol SaveListNameDelegateProtocol: class {
    func saveName(_ name: String, for list: List)
}

class ListModel {
    
    weak var view: ListViewProtocol?
        
    var storageManager: StorageManagerProtocol
    
    init(currentList: List, storageManager: StorageManagerProtocol) {
        self.currentList = currentList
        self.storageManager = storageManager
    }
    
    var currentList: List // for fetching of cards
    var cards: [Card] = []  // for controllers and speach
    var cardsForDeleting: [Card] = []
    
    func isPreparedForDeleting(card: Card) -> Bool {
        cardsForDeleting.contains(card)
    }
    
    func prepareCardForDeleting(card: Card) {
        cardsForDeleting.append(card)
    }
    
    func restoreCard(card: Card) {
        cardsForDeleting.removeAll { $0 == card }
    }
    
    func addNewCard(card: Card) {
        cards.append(card)
        do {
            try storageManager.storeNewCard(card)
        } catch {}
        view?.needsReload()
    }
    
    func removeCard(card: Card) {
        cards.removeAll { $0 == card }
        do {
            try storageManager.deleteCard(card)
        } catch {}
    }
    
    func deleteCards() {
        cardsForDeleting.forEach { removeCard(card: $0) }
        view?.needsReload()
    }
    
    func fetchCards() {
        storageManager.fetchCardsForList(list: currentList) { result in
            do {
                let cards = try result.get()
                self.cards = cards
            } catch {
                self.cards = []
            }
            self.view?.needsReload()
        }
    }
    
    
    func saveListName(_ name: String) {
        currentList.name = name
    }
    
    func editCardIfNeeded(card: Card) {
        if let index = cards.firstIndex(where: { $0.wordId == card.wordId }) {
            if cards[index].defaultIndex != card.defaultIndex {
                cards[index].defaultIndex = card.defaultIndex
                do {
                    try storageManager.storeCardDefaultIndex(card.defaultIndex, card: card)
                } catch {}
            }
            view?.needsReload()
        }
    }
    
    func storeCard(_ card: Card) {
        addNewCard(card: card)
    }
    
    func checkCard(_ card: Card) -> Bool {
        return cards.contains(card)
    }
    
    deinit {
        print("list model deinit")
    }
    
}
