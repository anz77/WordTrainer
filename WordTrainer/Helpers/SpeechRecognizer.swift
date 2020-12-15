//
//  SpeechRecognizer.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 28.10.2020.
//

import Foundation
import Speech

class SpeechRecognitionService2: NSObject {
    
    var availability: (Bool)->()
    var listening: (Bool)->()
    var output: (String)->()
    
    var onDeviceRecognitionAvailable = false
    
    init(availability: @escaping (Bool)->(), listening: @escaping (Bool)->(), output: @escaping (String)->()) {
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
        print("speechRecognizer.isAvailable = \(speechRecognizer.isAvailable)")
        //onDeviceRecognitionAvailable = checkForOnDeviceRecognition()
        speechRecognizer.delegate = self
        checkAvailability()
    }
    
//    func start() {
//        print("start")
//        if audioEngine.isRunning {
//            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
//            audioEngine.stop()
//            recognitionRequest?.endAudio()
//            listening(false)
//        } else {
//            do {
//                listening(true)
//                try startRecording()
//            } catch {
//                listening(false)
//                print(error)
//            }
//        }
//    }
    
    func start() {
        print("start")
        do {
            listening(true)
            try startRecording()
        } catch {
            listening(false)
            print(error)
        }
    }
    
    func cancelRecording() {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        recognitionTask?.finish()
        //recognitionTask?.cancel()
        self.recognitionRequest = nil
        self.recognitionTask = nil
    }
    
    func stopRecording() {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        recognitionTask?.finish()
        self.recognitionRequest = nil
        self.recognitionTask = nil
    }
    
    private func startRecording() throws {
        
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = false

        //enableOnDeviceRecognitionForRequest(recognitionRequest)
            
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            if let result = result {
                self.output(result.bestTranscription.formattedString)
                isFinal = result.isFinal
                print("result is final = \(isFinal)")
            }
                        
            if error != nil || isFinal {
                print("reconition error ===>>> \(String(describing: error))")
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.listening(false)
            }
            
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        self.output("(Go ahead, I'm listening)")
    }
    
    func enableOnDeviceRecognitionForRequest(_ recognitionRequest: SFSpeechAudioBufferRecognitionRequest) {
        
//        if #available(iOS 13, *) {
//            //recognitionRequest.requiresOnDeviceRecognition = true
//            if speechRecognizer.supportsOnDeviceRecognition {
//                recognitionRequest.requiresOnDeviceRecognition = true
//            }
//        }
                
        recognitionRequest.requiresOnDeviceRecognition = onDeviceRecognitionAvailable
    }
    
}


extension SpeechRecognitionService2: SFSpeechRecognizerDelegate {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            debugPrint("delegate recognition available = \(speechRecognizer.isAvailable)")
            availability(true)
        } else {
            debugPrint("delegate recognition available = \(speechRecognizer.isAvailable)")
            availability(false)
        }
    }
}
