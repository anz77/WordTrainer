//
//  SpeechModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 03.12.2020.
//

import Foundation

protocol SpeechModelProtocol: class {
    // output
    var viewDisableControl: (() -> ())? {get set}
    var viewEnableControl: (() -> ())? {get set}
    var viewSetListen: (() -> ())? {get set}
    var viewSetReady: (() -> ())? {get set}
    var viewSetRecognitionOutput: ((String) -> ())? {get set}
    var viewSetCurrentQuestion: ((String) -> ())? {get set}
    // input
    func cancelRecognition()
    func action()
    func configure()
    func next()
}

class SpeechModel {
    
    private var currentIndex: Int = 0
    
    // + SpeechModelProtocol output
    var viewDisableControl: (() -> ())?
    var viewEnableControl: (() -> ())?
    var viewSetListen: (() -> ())?
    var viewSetReady: (() -> ())?
    var viewSetRecognitionOutput: ((String) -> ())?
    var viewSetCurrentQuestion: ((String) -> ())?
    // - SpeechModelProtocol
    
    var recognitionService: SpeechRecognitionServiceProtocol?
    var storageManager: StorageManagerProtocol?
    
    private var recognizerAuthorized: Bool = false
    private var recognitionAvailable: Bool = false
    private var listen: Bool = false
    private var recognizedString: String = ""
    
    private var cards: Array<Card>
    //private var currentCard: Card?
    
    init(cards: [Card] = []) {
        self.cards = cards
    }
    
    private func cofigureRecognitionService() {
        recognitionService?.configure()
        recognitionService?.authorization = { [weak self] (authorized: Bool) -> Void in
            self?.authorization(authorized: authorized)
        }
        recognitionService?.availability = { [weak self] (available: Bool) -> Void in
            self?.availability(available: available)
        }
        recognitionService?.listening = { [weak self] (listen: Bool) -> Void in
            self?.listening(listen: listen)
        }
        recognitionService?.output = { [weak self] (output: Result<String, Error>) -> Void in
            self?.output(output: output)
        }
    }
    
    private func authorization(authorized: Bool) {
        self.recognizerAuthorized = authorized
    }
    
    private func availability(available: Bool) {
        self.recognitionAvailable = available
        available ? viewEnableControl?() : viewDisableControl?()
    }
    
    private func listening(listen: Bool) {
        self.listen = listen
        listen ? viewSetListen?() : viewSetReady?()
    }
    
    private func output(output: Result<String, Error>) {
        do {
            let string = try output.get()
            debugPrint("........................\(string)")
            recognizedString = string
            viewSetRecognitionOutput?(string)
        } catch {
            debugPrint("ERROR :::: \(error)")
        }
    }
    
}

extension SpeechModel {
    private func stop() {
        
    }
    
    private func start() {
        
    }
}


extension SpeechModel: SpeechModelProtocol {
    func configure() {
        cofigureRecognitionService()
    }

    func cancelRecognition() {
        recognitionService?.cancel()
    }
    
    func action() {
        self.listen ? recognitionService?.stop() : recognitionService?.start()
    }
    
    func next() {
        currentIndex += 1
        //currentCard = cards[currentIndex]
    }
}
