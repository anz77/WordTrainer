//
//  RawDictWord.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 29.10.2020.
//

import Foundation

struct RawDictWord {
    var key: String = ""
    //var word: String?
    //var tr: String = ""
    var values: String = ""
}

extension RawDictWord: Codable {}

extension RawDictWord: Hashable {}
