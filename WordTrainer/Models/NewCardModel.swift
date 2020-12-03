//
//  NewCardModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import Foundation

protocol NewCardViewProtocol: class {
    
}

protocol StoreCardDelegateProtocol: class {
    func storeCard(_ card: Card)
}


class NewCardModel {
    
    weak var view: NewCardViewProtocol?
    weak var storeCardDelegate: StoreCardDelegateProtocol?
    
    var storageManager: StorageManagerProtocol
    
    var card: Card
    
    var alreadyInList: Bool = false
    
    init(card: Card, storageManager: StorageManagerProtocol) {
        self.card = card
        self.storageManager = storageManager
    }
    
    func storeCard() {
        storeCardDelegate?.storeCard(card)
    }

}
