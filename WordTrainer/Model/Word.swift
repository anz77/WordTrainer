//
//  Word.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 23.10.2020.
//

import Foundation

struct Word {
    var key: String
    var id: UUID
    var word: String
    var values: [String]
    
    init(key: String, id: UUID = UUID(), word: String = "", values: [String]) {
        self.key = key
        self.id = id
        self.word = word
        self.values = values
    }
}

extension Word: Hashable {}
