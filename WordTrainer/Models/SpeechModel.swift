//
//  SpeechModel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 03.12.2020.
//

import Foundation

protocol SpeechModelProtocol: class {
    // output
    var viewEnableControl: ((Bool) -> ())? {get set}
    var viewSetRecording: (() -> ())? {get set}
    var viewSetReady: (() -> ())? {get set}
    var viewDisplayRecognitionOutput: ((String) -> ())? {get set}
    var viewDisplayQuestion: ((String) -> ())? {get set}
    var viewDisplayAnswer: ((String) -> ())? {get set}
    var viewDispalayEqual: ((Bool) -> ())? {get set}
    // input
    func cancelRecognition()
    func action()
    func configure()
    func iterate()
    func speakWord()
}

class SpeechModel {
    
    private var currentIndex: Int = 0
    
    // + SpeechModelProtocol output
    var viewEnableControl: ((Bool) -> ())?
    var viewSetRecording: (() -> ())?
    var viewSetReady: (() -> ())?
    var viewDisplayRecognitionOutput: ((String) -> ())?
    var viewDisplayQuestion: ((String) -> ())?
    var viewDisplayAnswer: ((String) -> ())?
    var viewDispalayEqual: ((Bool) -> ())?
    // - SpeechModelProtocol
    
    var recognitionService: SpeechRecognitionServiceProtocol?
    var storageManager: StorageManagerProtocol?
    
    private var recognizerAuthorized: Bool = false
    private var recognitionAvailable: Bool = false
    private var listeningEnabled: Bool = false
    private var recording: Bool = false
    private var recognizedString: String = " "
    
    private var cards: Array<Card> = []
    
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
        recognitionService?.recording = { [weak self] (recording: Bool) -> Void in
            self?.recording(recording)
        }
        recognitionService?.output = { [weak self] (output: Result<(String, Bool), Error>) -> Void in
            self?.output(output: output)
        }
    }
    
    private func authorization(authorized: Bool) {
        recognizerAuthorized = authorized
    }
    
    private func availability(available: Bool) {
        recognitionAvailable = available
        available ? viewEnableControl?(true) : viewEnableControl?(false)
        let card = cards[currentIndex]
        available ? viewDisplayQuestion?(card.values[card.defaultIndex]) : viewDisplayQuestion?("")
    }
    
    private func recording(_ recording: Bool) {
        self.recording = recording
        recording ? viewSetRecording?() : {}()  //viewSetReady?()
    }
    
    private func output(output: Result<(String, Bool), Error>) {
        do {
            let outputTuple = try output.get()
            //debugPrint("........................\(outputTuple.0)")
            recognizedString = outputTuple.0
            viewDisplayRecognitionOutput?(outputTuple.0)
            if outputTuple.1 {
                endDictation()
            }
        } catch {
            endDictation()
            //debugPrint("ERROR :::: \(error)")
        }
    }
    
}

extension SpeechModel {
    private func stop() {
        recognitionService?.stop()
    }
    
    private func start() {
        viewDisplayAnswer?(" ")
        viewDisplayRecognitionOutput?(" ")
        recognitionService?.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.stop() }
    }
}


extension SpeechModel: SpeechModelProtocol {
    
    func speakWord() {
        let syntesizeService = SpeechSyntesizerService()
        syntesizeService.speechUttreance(string: cards[currentIndex].word)
    }
    
    func configure() {
        cofigureRecognitionService()
    }

    func cancelRecognition() {
        recognitionService?.cancel()
    }
    
    func action() {
        listeningEnabled ? speakWord() : (recording ? stop() : start())
    }
    
    func iterate() {
        viewSetReady?()
        viewDisplayRecognitionOutput?(" ")
        viewDisplayAnswer?(" ")
        currentIndex < cards.count - 1 ? stepToNextCard() : restartIteration()
        listeningEnabled = false
    }
    
    func stepToNextCard() {
        currentIndex += 1
        let card = cards[currentIndex]
        viewDisplayQuestion?(card.values[card.defaultIndex])
    }
    
    func restartIteration() {
        currentIndex = 0
        let card = cards[currentIndex]
        viewDisplayQuestion?(card.values[card.defaultIndex])
    }
    
    func endDictation() {
        cards[currentIndex].word.lowercased() == recognizedString.lowercased() ? setSuccess() : setFailure()
        listeningEnabled = true
    }
    
    func setSuccess() {
        viewDispalayEqual?(true)
    }
    
    func setFailure() {
        viewDisplayAnswer?(cards[currentIndex].word + "\n[transcription]")
        viewDispalayEqual?(false)
    }
    
}
