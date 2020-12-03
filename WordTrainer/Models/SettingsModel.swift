//
//  SettingsModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import Foundation

protocol SettingsViewProtocol: class {
    func needsReload()
}

class SettingsModel {
    
    weak var view: SettingsViewProtocol?
    
    var storageManager: StorageManagerProtocol
    
    var allLists: [List] = [] // for view controllers
    
    var listsForDeleting: [List] = []
        
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }
    
    func prepareListForDeleting(list: List) {
        listsForDeleting.append(list)
    }
    
    func isPreparedForDeleting(list: List) -> Bool {
        listsForDeleting.contains(list)
    }
    
    func restoreList(list: List) {
        listsForDeleting.removeAll {
            $0 == list
        }
    }
    
    func deleteLists() {
        listsForDeleting.forEach { (list) in
            removeList(list: list)
            view?.needsReload()
        }
    }

    func removeList(list: List) {
        allLists.removeAll {
            $0.listId == list.listId
        }
        do {
            try storageManager.deleteList(list)
            try storageManager.deleteCardsInList(list)
        } catch {}
    }
    
    func addNewList(name: String) {
        let list = List(name: name, listId: UUID(), isDefault: true)
        allLists.append(list)
        allLists.sort { $0 < $1 }
        view?.needsReload()
        do {
            try storageManager.storeNewList(list: list)
        } catch {}
    }

    func fetchLists() {
        storageManager.fetchAllLists { result in
            do {
                let lists = try result.get()
                self.allLists = lists
                self.view?.needsReload()
            } catch {
                self.allLists = []
                self.view?.needsReload()
            }
        }
    }
}

extension SettingsModel: SaveListNameDelegateProtocol {
    func saveName(_ name: String, for list: List) {
        if let index = allLists.firstIndex(where: { $0.listId == list.listId }) {
            if allLists[index].name != list.name {
                allLists[index].name = list.name
                do {
                    try storageManager.storeNameForList(name: name, list: list)
                } catch {}
                view?.needsReload()
            }
        }
    }
    
    
}
