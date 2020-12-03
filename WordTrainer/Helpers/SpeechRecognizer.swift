//
//  SpeechRecognizer.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 28.10.2020.
//

import Foundation
import Speech


class SpeechRecognitionManager: NSObject {
    
    weak var delegate: SpeechRecognitionManagerDelegate?
    
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    func configure() {
        speechRecognizer.delegate = self

        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.delegate?.state = .authorized
                case .denied:
                    self.delegate?.state = .authDenied
                case .restricted:
                    self.delegate?.state = .authRestricted
                case .notDetermined:
                    self.delegate?.state = .authNotDetermined
                @unknown default: fatalError()
                }
            }
        }
    }
    
    
    func start() {
        print("speechRecognizer.isAvailable = \(speechRecognizer.isAvailable)")

        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            self.delegate?.state = .recordingIsStopping
        } else {
            do {
                try startRecording()
                self.delegate?.state = .recordingStarted
            } catch {
                self.delegate?.state = .recordingNotAvailable
                print(error)
            }
        }
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
        recognitionRequest.shouldReportPartialResults = true
        
        if #available(iOS 13, *) {
            //recognitionRequest.requiresOnDeviceRecognition = true
            if speechRecognizer.supportsOnDeviceRecognition {
                recognitionRequest.requiresOnDeviceRecognition = true
            }
        }
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false

            if let result = result {
                self.delegate?.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                debugPrint("Text \(result.bestTranscription.formattedString)")
            }
            
            if error != nil || isFinal {
                print(error ?? "no error")
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.delegate?.state = .recognitionAvailable
            }
            
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        self.delegate?.text = "(Go ahead, I'm listening)"
    }
    
}


extension SpeechRecognitionManager: SFSpeechRecognizerDelegate {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            debugPrint("delegate recognition available = \(speechRecognizer.isAvailable)")
            //print("delegate onDevice available = \(speechRecognizer.supportsOnDeviceRecognition)")
            self.delegate?.state = .recognitionAvailable
        } else {
            debugPrint("delegate recognition available = \(speechRecognizer.isAvailable)")
            //print("delegate onDevice available = \(speechRecognizer.supportsOnDeviceRecognition)")
            self.delegate?.state = .recognitionNotAvailable
        }
    }
}


enum SpeachRecognitionState {
    
    case notDetermined
    
    case authorized
    case authDenied
    case authRestricted
    case authNotDetermined
    
    case recordingIsStopping
    case recordingStarted
    case recordingNotAvailable
    
    case recognitionAvailable
    case recognitionNotAvailable
    
}
