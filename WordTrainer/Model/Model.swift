//
//  Model.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 24.10.2020.
//

import Foundation

class Model {
    
    let storageManager = StorageManager()
    
    var wordListsArray: [WordList] = []
    
    init() {
        let list1 = WordList(name: "Nouns", wordCards: [WordCard(key: "abbreviated", word: Word(key: "abbreviated", values: ["сокращенный, укороченный", "короткий, едва прикрывающий наготу"]), successCount: 0, failureCount: 0),])
        self.wordListsArray = [list1]

    }
    
    func getWordFromPersistentStorage(word: String) -> Word? {
        return Word(key: word, values: ["hgfjdagfhgfdslj dgfjghdjshjsd"])
    }
    
    func getWordCardFromPersistentStorage(word: String) -> WordCard? {
        return WordCard(key: "abbreviated", word: Word(key: "abbreviated", values: ["сокращенный, укороченный", "короткий, едва прикрывающий наготу"]), successCount: 0, failureCount: 0)
    }
    
    func addWordCard(_ card: WordCard, to list: WordList) {
        
    }
    
    func makeCardFromWord(_ word: Word) -> WordCard? {
        return WordCard(key: "abbreviated", word: Word(key: "abbreviated", values: ["сокращенный, укороченный", "короткий, едва прикрывающий наготу"]), successCount: 0, failureCount: 0)
    }
    
    func searchWordInPersistentStorage(word: String, completion: @escaping ([Word])->()) {
        
    }
}


//        let wordCard
//        //self.wordListsArray = []
//        self.wordListsArray = [WordList(name: "First", wordCards: [Word(key: "abbreviated", values: ["сокращенный, укороченный", "короткий, едва прикрывающий наготу"]),
//                                                                   Word(key: "abbreviation", values: ["сокращение (действие), аббревиация", "сокращение, аббревиатура", "аббревиатура, упрощение нотного письма"]),
//                                                                   Word(key: "abbreviator", values: ["составитель папского бреве"]),
//                                                                   Word(key: "abbreviature", values: ["сокращенное изложение", "сокращение, аббревиатура"]),
//                                                                   Word(key: "abc abc", values: ["алфавит, азбука", "букварь", "основы, начатки", "железнодорожный указатель, путеводитель", "атомный, биологический и химический"]),
//                                                                   Word(key: "abc art", values: ["упрощенное искусство (абстрактное, преимущественно использующее геометрические фигуры)"]),
//                                                                   Word(key: "abc powers", values: ["Аргентина, Бразилия, Чили"]),
//                                                                   Word(key: "abcbook", values: ["букварь"]),
//                                                                   Word(key: "abdest", values: ["абдест (омовение рук у мусульман)"]),
//                                                                   Word(key: "abdicant", values: ["человек, отрекающийся, отказывающийся от чего-л.", "отказывающийся, отрекающийся"]),
//                                                                   Word(key: "zz", values: ["26-я буква английского алфавита", "зет, неизвестная величина", "в грам. знач. прил. (тж. как компонент сложных слов): имеющий форму буквы Z;  Z-образный"]),]),
//                               WordList(name: "Second", wordCards: [Word(key: "abbreviated", values: ["сокращенный, укороченный", "короткий, едва прикрывающий наготу"]),
//                                                                    Word(key: "abbreviation", values: ["сокращение (действие), аббревиация", "сокращение, аббревиатура", "аббревиатура, упрощение нотного письма"]),
//                                                                    Word(key: "abbreviator", values: ["составитель папского бреве"]),
//                                                                    Word(key: "abbreviature", values: ["сокращенное изложение", "сокращение, аббревиатура"]),
//                                                                    Word(key: "abc abc", values: ["алфавит, азбука", "букварь", "основы, начатки", "железнодорожный указатель, путеводитель", "атомный, биологический и химический"]),
//                                                                    Word(key: "abc art", values: ["упрощенное искусство (абстрактное, преимущественно использующее геометрические фигуры)"]),
//                                                                    Word(key: "abc powers", values: ["Аргентина, Бразилия, Чили"]),
//                                                                    Word(key: "abcbook", values: ["букварь"]),
//                                                                    Word(key: "abdest", values: ["абдест (омовение рук у мусульман)"]),
//                                                                    Word(key: "abdicant", values: ["человек, отрекающийся, отказывающийся от чего-л.", "отказывающийся, отрекающийся"]),
//                                                                    Word(key: "zz", values: ["26-я буква английского алфавита", "зет, неизвестная величина", "в грам. знач. прил. (тж. как компонент сложных слов): имеющий форму буквы Z;  Z-образный"]),])
//        ]
