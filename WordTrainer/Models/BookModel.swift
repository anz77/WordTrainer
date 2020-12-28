//
//  BookModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import Foundation

protocol BookModelProtocol: class {
    func modelsStorageManager() -> StorageManagerProtocol?
    var viewNeedsReload: (()->())? {get set}
    func configureItemWithIndex(_ index: Int, completion: @escaping (List, Bool)->())
    func fetchLists()
    func cleanListsForDeleting()
    func deleteLists()
    func addNewList(name: String)
    func saveName(_ name: String, for list: List)
    func listForIndex(_ index: Int) -> List
    func listsCount() -> Int
    func managePreparationForDeleting(list: List)
}

class BookModel {
    var viewNeedsReload: (() -> ())?
    var storageManager: StorageManagerProtocol?
    
    private var lists: [List] = []
    private var listsForDeleting: [List] = []
}

extension BookModel: BookModelProtocol {
    
    func managePreparationForDeleting(list: List) {
        listsForDeleting.contains(list) ? listsForDeleting.removeAll { $0 == list } : listsForDeleting.append(list)
    }
    
    func configureItemWithIndex(_ index: Int, completion: @escaping (List, Bool)->()) {
        completion(lists[index], listsForDeleting.contains(lists[index]))
    }
    
    func modelsStorageManager() -> StorageManagerProtocol? {
        storageManager
    }
    
    func deleteLists() {
        listsForDeleting.forEach { listForDeleting in
            self.lists.removeAll { list -> Bool in
                list == listForDeleting
            }
            do {
                try storageManager?.deleteList(listForDeleting)
                try storageManager?.deleteCardsInList(listForDeleting)
            } catch {
                debugPrint(error)
            }
        }
        viewNeedsReload?()
    }
    
    func addNewList(name: String) {
        let list = List(name: name, listId: UUID())
        lists.append(list)
        lists.sort { $0 < $1 }
        viewNeedsReload?()
        do {
            try storageManager?.storeNewList(list: list)
        } catch {
            debugPrint(error)
        }
    }
    
    func fetchLists() {
        storageManager?.fetchAllLists { result in
            do {
                let lists = try result.get()
                self.lists = lists
                self.viewNeedsReload?()
            } catch {
                self.lists = []
                self.viewNeedsReload?()
                debugPrint(error)
            }
        }
    }
    
    func cleanListsForDeleting() {
        listsForDeleting = []
        viewNeedsReload?()
    }
    
    func listForIndex(_ index: Int) -> List {
        lists[index]
    }
    
    func listsCount() -> Int {
        lists.count
    }
    
    func saveName(_ name: String, for list: List) {
        if let index = lists.firstIndex(where: { $0.listId == list.listId }) {
            if lists[index].name != list.name {
                lists[index].name = list.name
                do {
                    try storageManager?.storeNameForList(name: name, list: list)
                } catch {
                    debugPrint(error)
                }
                viewNeedsReload?()
            }
        }
    }
}



