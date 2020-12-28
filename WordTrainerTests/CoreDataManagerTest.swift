//
//  CoreDataTest.swift
//  WordTrainerTests
//
//  Created by ANDRII ZUIOK on 17.12.2020.
//

import XCTest
import CoreData
@testable import WordTrainer

class CoreDataTest: XCTestCase {
    
    var sut: CoreDataManager!
    var coreDataStack: CoreDataStack!
    let wordId_1 = UUID()
    let wordId_2 = UUID()
    let listId_1 = UUID()
    let listId_2 = UUID()
    var defaultList_1: List { List(name: "List_1", listId: listId_1) }
    var defaultList_2: List { List(name: "List_2", listId: listId_2) }
    var defaultCard_11: Card { Card(word: "word_11", wordId: UUID(), listId: listId_1, values: ["first", "last"]) }
    var defaultCard_12: Card { Card(word: "word_11", wordId: UUID(), listId: listId_1, values: ["first", "last"]) }
    var defaultCard_21: Card { Card(word: "word_21", wordId: UUID(), listId: listId_2, values: ["previous", "next"]) }
    var defaultCard_22: Card { Card(word: "word_22", wordId: UUID(), listId: listId_2, values: ["previous", "next"]) }
    
    var defaultWord_1: Word { Word(key: "key_1", id: wordId_1, word: "word_1", values: ["value_11", "value_12"]) }
    var defaultWord_2: Word { Word(key: "key_2", id: wordId_1, word: "word_2", values: ["value_21", "value_22"]) }
    
    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack(modelName: "WordTrainer")
        sut = CoreDataManager()
        sut.coreDataStack = coreDataStack
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        coreDataStack = nil
    }
    
    func testPopulateAndCleanStorage() {
        let word_1 = defaultWord_1
        let word_2 = defaultWord_2
        
        try? sut.populateStorage(words: [word_1, word_2])
        var fetchedWords: [Word]?
        sut.fetchWord(word_1.key) {
            try? fetchedWords = $0.get()
        }
        
        XCTAssertNotNil(fetchedWords, "words is nil")
        XCTAssertEqual(fetchedWords?.count, 1)
//        fetchedWords?.forEach({ word in
//            XCTAssertEqual(word.key, word_1.key)
//        })
        
        try? sut.fetchAllWordsAndCleanDatabase()
        
        sut.fetchWord(word_1.key) { try? fetchedWords = $0.get() }
        
        XCTAssertEqual(fetchedWords?.count, 0)
    }
    
    func testStoreFetchDeleteList() {
        let list_1 = defaultList_1
        let list_2 = defaultList_2

        try? sut.storeNewList(list: list_1)
        try? sut.storeNewList(list: list_2)
        
        var fetchedLists: [List]?
        sut.fetchAllLists { try? fetchedLists = $0.get() }
        
        XCTAssertNotNil(fetchedLists, "lists is nil")
        XCTAssertEqual(fetchedLists?.count, 2)
        
        try? sut.deleteList(list_1)
        try? sut.deleteList(list_2)

        sut.fetchAllLists { try? fetchedLists = $0.get() }
        
        XCTAssertNotNil(fetchedLists, "lists is nil")
        XCTAssertEqual(fetchedLists?.count, 0)
    }
    
    func testStoreFetchDeleteCardForList() {
        let list = defaultList_1
        let card_1 = defaultCard_11
        let card_2 = defaultCard_12
        try? sut.storeNewCard(card_1)
        try? sut.storeNewCard(card_2)

        var fetchedCards: [Card]?
        
        sut.fetchCardsForList(list: list, { try? fetchedCards = $0.get() })
        
        XCTAssertNotNil(fetchedCards, "cards is nil")
        XCTAssertEqual(fetchedCards?.count, 2)
//        fetchedCards?.forEach({ card in
//            XCTAssertEqual(card.listId, list.listId)
//        })
        
        try? sut.deleteCardsInList(list)
        
        sut.fetchCardsForList(list: list, { try? fetchedCards = $0.get() })
        
        XCTAssertNotNil(fetchedCards, "cards is nil")
        XCTAssertEqual(fetchedCards?.count, 0)
    }
    
    func testChangeCard() {
        let list_1 = defaultList_1
        let card_1 = defaultCard_11
        try? sut.storeNewCard(card_1)

        try? sut.storeCardSuccess(1, card: card_1)
        try? sut.storeCardFailure(1, card: card_1)
        try? sut.storeCardDefaultIndex(1, card: card_1)
        
        var fetchedCards: [Card]?
        
        sut.fetchCardsForList(list: list_1, { try? fetchedCards = $0.get() })
        
        XCTAssertEqual(fetchedCards?.count, 1)
        XCTAssertEqual(fetchedCards?[0].successCount, 1)
        XCTAssertEqual(fetchedCards?[0].failureCount, 1)
        XCTAssertEqual(fetchedCards?[0].defaultIndex, 1)

        try? sut.deleteCard(card_1)
        
        sut.fetchCardsForList(list: list_1, { try? fetchedCards = $0.get() })
        XCTAssertEqual(fetchedCards?.count, 0)
    }
    
    func testChangeList() {
        
        let list_1 = defaultList_1
        let newName = "NewName"
        
        try? sut.storeNewList(list: list_1)
        try? sut.storeNameForList(name: newName, list: list_1)
        
        //try? coreDataManager.storeIsDefaultForList(isDefault: false, list: list_1)

        var fetchedLists: [List]?
        sut.fetchAllLists { try? fetchedLists = $0.get() }
        
        XCTAssertEqual(fetchedLists?.count, 1)
        XCTAssertEqual(fetchedLists?[0].name, newName)
    }
    
}
