//
//  WordList.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 29.10.2020.
//

import Foundation

class WordList {
    
    var name: String = ""
    var wordCards: [WordCard] = []
    
    init(name: String, wordCards: [WordCard]) {
        self.name = name
        self.wordCards = wordCards
    }
}
