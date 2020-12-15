//
//  StartModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 03.12.2020.
//

import Foundation

class StartModel {
    
    weak var view: StartViewProtocol?
    
    lazy var storageManager: CoreDataManager = {
        let manager = CoreDataManager()
        return manager
    }()
    
}
