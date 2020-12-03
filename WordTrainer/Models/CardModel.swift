//
//  CardModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import Foundation


protocol CardViewProtocol: class {
    
}

protocol EditCardProtocol: class {
    func editCardIfNeeded(card: Card)
}

class CardModel {
    
    weak var view: CardViewProtocol?
    var storageManager: StorageManagerProtocol
    
    weak var editCardDelegate: EditCardProtocol?
    
    var card: Card
    
    init(card: Card, storageManager: StorageManagerProtocol) {
        self.card = card
        self.storageManager = storageManager
    }
    
    func removeCard(card: Card) {
        
    }
    
    func editCardIfNeeded() {
        editCardDelegate?.editCardIfNeeded(card: card)
    }
    
    
}
