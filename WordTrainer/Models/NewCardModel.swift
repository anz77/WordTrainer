//
//  NewCardModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import Foundation

protocol StoreCardDelegateProtocol: class {
    func storeCard(_ card: Card)
}

class NewCardModel {
    
    weak var view: NewCardViewProtocol?
    
    var card: Card
    
    var alreadyInList: Bool = false
    
    init(card: Card) {
        self.card = card
    }
}
