//
//  NewCardModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import Foundation

protocol NewCardModelProtocol: CardModelProtocol {
    func setAlreadyInList(_ alreadyInList: Bool)
    func isAlreadyInList() -> Bool
}

protocol StoreCardDelegateProtocol: class {
    func storeCard(_ card: Card)
}

class NewCardModel: CardModel {
    
    private var alreadyInList: Bool = false
    
    override init(card: Card) {
        super.init(card: card)
    }
}

extension NewCardModel: NewCardModelProtocol {
    
    func isAlreadyInList() -> Bool {
        alreadyInList
    }
    
    func setAlreadyInList(_ alreadyInList: Bool) {
        self.alreadyInList = alreadyInList
    }
}


