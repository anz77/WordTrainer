//
//  SpeechRecognitionService.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 28.10.2020.
//

import Foundation
import Speech

protocol SpeechRecognitionServiceProtocol: class {
    var authorization: ((Bool)->())? {get set}
    var availability: ((Bool)->())? {get set}
    var listening: ((Bool)->())? {get set}
    var output: ((Result<String, Error>)->())? {get set}
    
    func configure()
    func start()
    func cancel()
    func stop()
}

class SpeechRecognitionService: NSObject, SpeechRecognitionServiceProtocol {
    
    var authorization: ((Bool)->())?
    var availability: ((Bool)->())?
    var listening: ((Bool)->())?
    var output: ((Result<String, Error>)->())?

    var onDeviceRecognitionAvailable = false

    var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    func configure() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Authorized")
                    self.authorization?(true)
                    self.setSpeechRecognizer()
                case .denied:
                    self.authorization?(false)
                case .restricted:
                    self.authorization?(false)
                case .notDetermined:
                    self.authorization?(false)
                @unknown default:
                    self.authorization?(false)
                }
            }
        }
    }
    
    private func setSpeechRecognizer() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
        //onDeviceRecognitionAvailable = checkForOnDeviceRecognition()
        speechRecognizer?.delegate = self
        checkAvailability()
    }
    
    private func checkForOnDeviceRecognition() -> Bool {
        guard let speechRecognizer = speechRecognizer else { return false }
        return speechRecognizer.supportsOnDeviceRecognition
    }
    
    private func checkAvailability() {
        guard let speechRecognizer = speechRecognizer else {return}
        availability?(speechRecognizer.isAvailable)
    }
    
    
    
    func start() {
        
        listening?(true)
        startRecording()
        debugPrint("START")

    }
    
    func cancel() {
        recognitionTask?.cancel()
        debugPrint("CANCELLED")
    }
    
    func stop() {
        recognitionTask?.finish()
        debugPrint("STOPPED")
    }
    
    private func startRecording() {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        } catch let error {
            output?(.failure(error))
            listening?(false)
        }
        do {
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error {
            output?(.failure(error))
            listening?(false)
        }
        let inputNode = audioEngine.inputNode

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        
        //recognitionRequest.requiresOnDeviceRecognition = onDeviceRecognitionAvailable

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.output?(.success(result.bestTranscription.formattedString))
                if result.isFinal {
                    debugPrint("-----task state = \(String(describing: self.recognitionTask?.state.rawValue))")
                    debugPrint("FINAL")
                    self.stopRecording()
                    inputNode.removeTap(onBus: 0)
                } else {
                    debugPrint("-----task state = \(String(describing: self.recognitionTask?.state.rawValue))")
                    debugPrint("CONTINUOUS")
                }
            }
            if let error = error {
                debugPrint("-----task state = \(String(describing: self.recognitionTask?.state.rawValue))")
                self.output?(.failure(error))
                self.stopRecording()
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
            output?(.failure(error))
            listening?(false)
        }
    }
    
    private func stopRecording() {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.recognitionRequest = nil
        self.recognitionTask = nil
        self.listening?(false)
        debugPrint("listening stopped")
    }
    
}

extension SpeechRecognitionService: SFSpeechRecognizerDelegate {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        available ? availability?(true) : availability?(false)
    }
}





//                print(result.transcriptions)
//                result.transcriptions.forEach {
//                    print($0.formattedString)
//                }