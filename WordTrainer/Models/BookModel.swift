//
//  BookModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import Foundation

class BookModel {
    
    weak var view: BookViewProtocol?
    
    var storageManager: StorageManagerProtocol
    
    var lists: [List] = []
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
        listsForDeleting.removeAll { $0 == list }
    }
    
    func removeList(list: List) {
        lists.removeAll { $0 == list }
        do {
            try storageManager.deleteList(list)
            try storageManager.deleteCardsInList(list)
        } catch {}
    }
    
    func deleteLists() {
        listsForDeleting.forEach { removeList(list: $0) }
        view?.needsReload()
    }    
    
    func addNewList(name: String) {
        let list = List(name: name, listId: UUID(), isDefault: true)
        lists.append(list)
        lists.sort { $0 < $1 }
        view?.needsReload()
        do {
            try storageManager.storeNewList(list: list)
        } catch {}
    }

    func fetchLists() {
        storageManager.fetchAllLists { result in
            do {
                let lists = try result.get()
                self.lists = lists
                self.view?.needsReload()
            } catch {
                self.lists = []
                self.view?.needsReload()
            }
        }
    }
    
    func saveName(_ name: String, for list: List) {
        if let index = lists.firstIndex(where: { $0.listId == list.listId }) {
            if lists[index].name != list.name {
                lists[index].name = list.name
                do {
                    try storageManager.storeNameForList(name: name, list: list)
                } catch {}
                view?.needsReload()
            }
        }
    }
}
