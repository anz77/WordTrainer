//
//  ListModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import Foundation

protocol ListModelProtocol: class {
    func modelsStorageManager() -> StorageManagerProtocol?
    var viewNeedsReload: (()->())? {get set}
    func configureItemWithIndex(_ index: Int, completion: @escaping (Card, Bool)->())
    func addNewCard(card: Card)
    func deleteCards()
    func fetchCards()
    func saveListName(_ name: String)
    func editCardIfNeeded(card: Card)
    func storeCard(_ card: Card)
    func checkCard(_ card: Card) -> Bool
    func cleanCardsForDeleting()
    func cardForIndex(_ index: Int) -> Card
    func cardsCount() -> Int
    func currentList() -> List
    func currentCards() -> [Card]
    func managePreparationForDeleting(card: Card)
}

class ListModel {
    var viewNeedsReload: (()->())?
    var storageManager: StorageManagerProtocol?
    
    init(list: List) {
        self.list = list
    }
    
    private var list: List
    private var cards: [Card] = []
    private var cardsForDeleting: [Card] = []
}

extension ListModel: ListModelProtocol {
    
    func configureItemWithIndex(_ index: Int, completion: @escaping (Card, Bool)->()) {
        completion(cards[index], cardsForDeleting.contains(cards[index]))
    }
    
    func managePreparationForDeleting(card: Card) {
        cardsForDeleting.contains(card) ? cardsForDeleting.removeAll { $0 == card } : cardsForDeleting.append(card)
    }
    
    func modelsStorageManager() -> StorageManagerProtocol? {
        storageManager
    }
    
    func addNewCard(card: Card) {
        cards.append(card)
        do {
            try storageManager?.storeNewCard(card)
        } catch {
            debugPrint(error)
        }
        viewNeedsReload?()
    }
    
    func deleteCards() {
        cardsForDeleting.forEach { cardForDeleting in
            cards.removeAll { card in
                card == cardForDeleting
            }
            do {
                try storageManager?.deleteCard(cardForDeleting)
            } catch {
                debugPrint(error)
            }
        }
        viewNeedsReload?()
    }
    
    func fetchCards() {
        storageManager?.fetchCardsForList(list: list) { result in
            do {
                let cards = try result.get()
                self.cards = cards
            } catch {
                self.cards = []
                debugPrint(error)
            }
            self.viewNeedsReload?()
        }
    }
    
    
    func saveListName(_ name: String) {
        list.name = name
    }
    
    func editCardIfNeeded(card: Card) {
        if let index = cards.firstIndex(where: { $0.wordId == card.wordId }) {
            if cards[index].defaultIndex != card.defaultIndex {
                cards[index].defaultIndex = card.defaultIndex
                do {
                    try storageManager?.storeCardDefaultIndex(card.defaultIndex, card: card)
                } catch {
                    debugPrint(error)
                }
            }
            viewNeedsReload?()
        }
    }
    
    func storeCard(_ card: Card) {
        addNewCard(card: card)
    }
    
    func checkCard(_ card: Card) -> Bool {
        return cards.contains(card)
    }
    
    func cleanCardsForDeleting() {
        cardsForDeleting = []
        viewNeedsReload?()
    }
    
    func cardForIndex(_ index: Int) -> Card {
        cards[index]
    }
    
    func cardsCount() -> Int {
        cards.count
    }
    
    func currentList() -> List {
        return list
    }
    
    func currentCards() -> [Card] {
        cards
    }
}
