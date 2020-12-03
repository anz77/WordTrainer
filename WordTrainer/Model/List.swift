//
//  List.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 29.10.2020.
//

import Foundation

struct List {
    
    var name: String
    var listId: UUID
    var isDefault: Bool
    //var cards: [Card]
    
    init(name: String = "", listId: UUID = UUID(), isDefault: Bool = false/*, cards: [Card] = []*/) {
        self.name = name
        self.listId = listId
        self.isDefault = isDefault
    }
}

extension List: Comparable, Hashable {
    
    // Equatable
    static func == (lhs: List, rhs: List) -> Bool {
        return lhs.listId == rhs.listId
    }
    
    static func < (lhs: List, rhs: List) -> Bool {
        lhs.name < rhs.name
    }
}


