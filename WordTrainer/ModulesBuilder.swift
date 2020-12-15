//
//  ModulesBuilder.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 04.12.2020.
//

import Foundation

class ModulesBuilder {
    
    static func configureBookViewController(storageManager: StorageManagerProtocol) -> BookViewController {
        let model = BookModel(storageManager: storageManager)
        let controller = BookViewController(model: model)
        model.view = controller
        return controller
    }
    
    static func configureSpeechViewController(cards: [Card], storageManager: StorageManagerProtocol) -> SpeechViewController {
        let model = SpeechModel(cards: cards, storageManager: storageManager)
        let controller = SpeechViewController(model: model)
        model.view = controller
        return controller
    }
    
    static func configurePreferencesController(storageManager: StorageManagerProtocol) -> PreferensesViewController {
        let preferencesModel = PreferensesModel(storageManager: storageManager)
        let controller = PreferensesViewController(model: preferencesModel)
        preferencesModel.view = controller
        return controller
    }
    
    static func configureListViewController(list: List, saveListNameDelegate: SaveListNameDelegateProtocol, storageManager: StorageManagerProtocol) -> ListViewController {
        let listModel = ListModel(currentList: list, storageManager: storageManager)
        let controller = ListViewController(model: listModel)
        listModel.view = controller
        controller.saveListNameDelegate = saveListNameDelegate
        return controller
    }
    
    static func configureCardViewController(card: Card, editCardDelegate: EditCardProtocol) -> CardViewController {
        let cardModel = CardModel(card: card)
        let controller = CardViewController(model: cardModel)
        controller.editCardDelegate = editCardDelegate
        cardModel.view = controller
        return controller
    }
    
    static func configureSearchViewController(list: List, cardCheckingDelegate: CardCheckingProtocol, storeCardDelegate: StoreCardDelegateProtocol, storageManager: StorageManagerProtocol) -> SearchViewController {
        let searchModel = SearchModel(currentList: list, storageManager: storageManager)
        let controller = SearchViewController(model: searchModel)
        controller.cardCheckingDelegate = cardCheckingDelegate
        controller.storeCardDelegate = storeCardDelegate
        searchModel.view = controller
        return controller
    }
    
    static func configureNewCardViewController(card: Card, alreadyInList: Bool, storeCardDelegate: StoreCardDelegateProtocol) -> NewCardViewController {
        let cardModel = NewCardModel(card: card)
        cardModel.alreadyInList = alreadyInList
        let controller = NewCardViewController(model: cardModel)
        controller.storeCardDelegate = storeCardDelegate
        cardModel.view = controller
        return controller
    }
    
    
}
