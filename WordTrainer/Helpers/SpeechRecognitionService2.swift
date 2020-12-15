//
//  SpeechRecognitionService2.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 08.12.2020.
//

import Foundation
import Speech

class SpeechRecognitionService: NSObject {
    
    var availability: (Bool)->()
    var listening: (Bool)->()
    var output: (Result<String, Error>)->()
    
    
    var onDeviceRecognitionAvailable = false
    
    init(availability: @escaping (Bool)->(), listening: @escaping (Bool)->(), output: @escaping (Result<String, Error>)->()) {
        self.availability = availability
        self.listening = listening
        self.output = output
    }
        
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    func checkForOnDeviceRecognition() -> Bool {
        return speechRecognizer.supportsOnDeviceRecognition
    }
    
    func checkAvailability() {
        availability(speechRecognizer.isAvailable)
    }
    
    func configure() {
        //print("speechRecognizer.isAvailable = \(speechRecognizer.isAvailable)")
        //onDeviceRecognitionAvailable = checkForOnDeviceRecognition()
        speechRecognizer.delegate = self
        checkAvailability()
    }
 
    func start() {
        print("start")
        listening(true)
        startRecording()
    }
    
    func cancelRecording() {
        recognitionTask?.cancel()
    }
    
    func stopRecording() {
        recognitionTask?.finish()
    }
    
    private func startRecording() {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        } catch let error {
            output(.failure(error))
            listening(false)
        }
        do {
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error {
            output(.failure(error))
            listening(false)
        }
        let inputNode = audioEngine.inputNode

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
            
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.output(.success(result.bestTranscription.formattedString))
                if result.isFinal {
                    self.stop()
                    inputNode.removeTap(onBus: 0)
                    print("FINAL")
                }
            }
            if let error = error {
                self.output(.failure(error))
                self.stop()
                inputNode.removeTap(onBus: 0)
            }
        }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch let error {
            output(.failure(error))
            listening(false)
        }
        self.output(.success(".....I'm listening....."))
    }
    
    func stop() {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.recognitionRequest = nil
        self.recognitionTask = nil
        self.listening(false)
    }
    
}


extension SpeechRecognitionService: SFSpeechRecognizerDelegate {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
        available ? availability(true) : availability(false)
//        if available {
//            debugPrint("delegate recognition available = \(speechRecognizer.isAvailable)")
//            availability(true)
//        } else {
//            debugPrint("delegate recognition available = \(speechRecognizer.isAvailable)")
//            availability(false)
//        }
    }
}
