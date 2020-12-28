//
//  ModulesBuilder.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 04.12.2020.
//

import Foundation

class ModulesBuilder {
    
    static func configureBookViewController(storageManager: StorageManagerProtocol?) -> BookViewController {
        let model = BookModel()
        model.storageManager = storageManager
        let controller = BookViewController(model: model)
        return controller
    }
    
    static func configureSpeechViewController(cards: [Card], storageManager: StorageManagerProtocol?) -> SpeechViewController {
        let speechRecognitinServise = SpeechRecognitionService()
        let model = SpeechModel(cards: cards)
        model.storageManager = storageManager
        model.recognitionService = speechRecognitinServise
        let controller = SpeechViewController(model: model)
        return controller
    }
    
    static func configureSettingsViewController(storageManager: StorageManagerProtocol?) -> SettingsViewController {
        let model = SettingsModel()
        model.storageManager = storageManager
        let controller = SettingsViewController(model: model)
        model.view = controller
        return controller
    }
    
    static func configureListViewController(list: List, saveListNameDelegate: SaveListNameDelegateProtocol, storageManager: StorageManagerProtocol?) -> ListViewController {
        let model = ListModel(list: list)
        model.storageManager = storageManager
        let controller = ListViewController(model: model)
        controller.saveListNameDelegate = saveListNameDelegate
        return controller
    }
    
    static func configureCardViewController(card: Card, editCardDelegate: EditCardProtocol) -> CardViewController {
        let model = CardModel(card: card)
        let controller = CardViewController(model: model)
        controller.editCardDelegate = editCardDelegate
        return controller
    }
    
    static func configureSearchViewController(list: List, cardCheckingDelegate: CardCheckingProtocol, storeCardDelegate: StoreCardDelegateProtocol, storageManager: StorageManagerProtocol?) -> SearchViewController {
        let model = SearchModel(list: list)
        model.storageManager = storageManager
        let controller = SearchViewController(model: model)
        controller.cardCheckingDelegate = cardCheckingDelegate
        controller.storeCardDelegate = storeCardDelegate
        return controller
    }
    
    static func configureNewCardViewController(card: Card, alreadyInList: Bool, storeCardDelegate: StoreCardDelegateProtocol) -> NewCardViewController {
        let model = NewCardModel(card: card)
        model.setAlreadyInList(alreadyInList)
        let controller = NewCardViewController(model: model)
        controller.storeCardDelegate = storeCardDelegate
        return controller
    }
    
    
}
