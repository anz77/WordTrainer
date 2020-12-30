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
    var recording: ((Bool)->())? {get set}
    var output: ((Result<(String, Bool), Error>)->())? {get set}
    
    func configure()
    func start()
    func cancel()
    func stop()
}

class SpeechRecognitionService: NSObject, SpeechRecognitionServiceProtocol {
    
    var authorization: ((Bool)->())?
    var availability: ((Bool)->())?
    var recording: ((Bool)->())?
    var output: ((Result<(String, Bool), Error>)->())?

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
        recording?(true)
        startRecording()
    }
    
    func cancel() {
        recognitionTask?.cancel()
    }
    
    func stop() {
        recognitionTask?.finish()
    }
    
    private func startRecording() {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        } catch let error {
            output?(.failure(error))
            recording?(false)
        }
        do {
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error {
            output?(.failure(error))
            recording?(false)
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
                
                
                if result.isFinal {
                    self.output?(.success((result.bestTranscription.formattedString, true)))
                    self.stopRecording()
                    inputNode.removeTap(onBus: 0)
                } else {
                    self.output?(.success((result.bestTranscription.formattedString, false)))
                }
            }
            if let error = error {
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
            recording?(false)
        }
    }
    
    private func stopRecording() {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.recognitionRequest = nil
        self.recognitionTask = nil
        self.recording?(false)
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
