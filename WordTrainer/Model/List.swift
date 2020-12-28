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
    
    init(name: String = "", listId: UUID = UUID()) {
        self.name = name
        self.listId = listId
    }
}

extension List:  Hashable {
    
    static func == (lhs: List, rhs: List) -> Bool {
        return lhs.listId == rhs.listId
    }
    
}

extension List: Comparable {
    static func < (lhs: List, rhs: List) -> Bool {
        lhs.name < rhs.name
    }
}


