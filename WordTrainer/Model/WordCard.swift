//
//  WordCard.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 29.10.2020.
//

import Foundation

struct WordCard: Codable {
    var key: String = ""
   // var transcription: String = ""
    var word: Word?
    var successCount: Int = 0
    var failureCount: Int = 0
}
