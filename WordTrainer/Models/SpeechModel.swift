//
//  SpeechModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 03.12.2020.
//

import Foundation
import Speech

class SpeechModel {
    
    weak var view: SpeechViewProtocol?
    
    var recognitionService: SpeechRecognitionService?
    var storageManager: StorageManagerProtocol
    
    var recognizerAuthorized: Bool = false
    var recognitionAvailable: Bool = false
    var listen: Bool = false
    var recognizedString: String = ""
    
    var cards: Array<Card> //= []
    var currentCard: Card?
    
    init(cards: [Card] = [], storageManager: StorageManagerProtocol) {
        self.cards = cards
        self.storageManager = storageManager
    }
    
    func setRecognitionService() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Authorized")
                    self.recognizerAuthorized = true
                    self.cofigureRecognitionService()
                case .denied:
                    self.recognizerAuthorized = false
                case .restricted:
                    self.recognizerAuthorized = false
                case .notDetermined:
                    self.recognizerAuthorized = false
                @unknown default:
                    self.recognizerAuthorized = false
                    fatalError()
                }
            }
        }
    }
    
    func cofigureRecognitionService() {
        
        let availability = { [weak self] (available: Bool) -> Void in
            self?.availability(available: available)
        }
        
        let listening = { [weak self] (listen: Bool) -> Void in
            self?.listening(listen: listen)
        }
        
        let output = { [weak self] (output: Result<String, Error>) -> Void in
            self?.output(output: output)
        }
        recognitionService = SpeechRecognitionService(availability: availability, listening: listening, output: output)
        self.recognitionService?.configure()
    }
    
    func availability(available: Bool) {
        self.recognitionAvailable = available
        available ? view?.enableControl() : view?.disableControl()
    }
    
    func listening(listen: Bool) {
        self.listen = listen
        listen ? view?.setListen() : view?.setReady()
    }
    
    func output(output: Result<String, Error>) {
        do {
            let string = try output.get()
            print("........................\(string)")
            recognizedString = string
            view?.setRecognitionOutput(string)
        } catch {
            print("ERROR :::: \(error)")
        }
    }
    
    func action() {
        self.listen ? recognitionService?.stopRecording() : recognitionService?.start()
    }
    
    func cancelRecognition() {
        recognitionService?.cancelRecording()
    }
    
    deinit {
        print("deinit")
    }
}
