//
//  CardModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import Foundation

protocol CardModelProtocol: class {
    var viewNeedsReload: (()->())? {get set}
    func configureItemWithIndex(_ index: Int, completion: @escaping (String)->())
    func currentCard() -> Card
    func cardDefaultIndex() -> Int
    func setCardDefaultIndex(_ index: Int)
    func cardValuesCount() -> Int
    func cardValueWihtIndex(_ index: Int) -> String
}

protocol EditCardProtocol: class {
    func editCardIfNeeded(card: Card)
}

class CardModel {
    
    var viewNeedsReload: (()->())?
            
    private var card: Card
    
    init(card: Card) {
        self.card = card
    }
}

extension CardModel: CardModelProtocol {
    
    func configureItemWithIndex(_ index: Int, completion: @escaping (String)->()) {
        completion(card.values[index])
    }

    func cardValueWihtIndex(_ index: Int) -> String {
        card.values[index]
    }
    
    func cardValuesCount() -> Int {
        card.values.count
    }
    
    func setCardDefaultIndex(_ index: Int) {
        card.defaultIndex = index
        viewNeedsReload?()
    }
    
    func cardDefaultIndex() -> Int {
        card.defaultIndex
    }
    
    func currentCard() -> Card {
        card
    }
    
}
