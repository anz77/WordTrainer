//
//  Card.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 29.10.2020.
//

import Foundation

struct Card {
    var word: String
    var wordId: UUID
    var listId: UUID
    var values: [String]
    var defaultIndex: Int
    var successCount: Int
    var failureCount: Int
    
    init(word: String, wordId: UUID, listId: UUID, values: [String], defaultIndex: Int = 0, successCount: Int = 0, failureCount: Int = 0) {
        self.word = word
        self.wordId = wordId
        self.listId = listId
        self.values = values
        self.defaultIndex = defaultIndex
        self.successCount = successCount
        self.failureCount = failureCount
    }
}

extension Card: Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.wordId == rhs.wordId
    }
}
