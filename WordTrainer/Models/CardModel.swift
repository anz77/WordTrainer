//
//  CardModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import Foundation

protocol EditCardProtocol: class {
    func editCardIfNeeded(card: Card)
}

class CardModel {
    
    weak var view: CardViewProtocol?
        
    var card: Card
    
    init(card: Card) {
        self.card = card
    }
    
}
