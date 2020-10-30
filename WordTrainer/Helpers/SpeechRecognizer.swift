//
//  SpeechRecognizer.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 28.10.2020.
//

import Foundation
import Speech


class Recognizer: NSObject {
    
    weak var delegate: SpeechRecognizerDelegate?
    
    var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    func set() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    }
    
    func configure() {
        
        // Configure the SFSpeechRecognizer object already stored in a local member variable.
        speechRecognizer?.delegate = self
        
        // Make the authorization request
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // The authorization status results in changes to the app’s interface, so process the results on the app’s main queue.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.delegate?.recordButton.isEnabled = true
                    
                case .denied:
                    self.delegate?.recordButton.isEnabled = false
                    self.delegate?.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.delegate?.recordButton.isEnabled = false
                    self.delegate?.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.delegate?.recordButton.isEnabled = false
                    self.delegate?.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                    
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    
    func start() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            self.delegate?.recordButton.isEnabled = false
            self.delegate?.recordButton.setTitle("Stopping", for: .disabled)
        } else {
            do {
                try startRecording()
                self.delegate?.recordButton.setTitle("Stop Recording", for: [])
            } catch {
                self.delegate?.recordButton.setTitle("Recording Not Available", for: [])
            }
        }
    }
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode

        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session. Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                self.delegate?.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                print("Text \(result.bestTranscription.formattedString)")
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.delegate?.recordButton.isEnabled = true
                self.delegate?.recordButton.setTitle("Start Recording", for: [])
            }
        }

        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        // Let the user know to start talking.
        self.delegate?.textView.text = "(Go ahead, I'm listening)"
    }
    
}


extension Recognizer: SFSpeechRecognizerDelegate {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            delegate?.recordButton.isEnabled = true
            delegate?.recordButton.setTitle("Start Recording", for: [])
        } else {
            delegate?.recordButton.isEnabled = false
            delegate?.recordButton.setTitle("Recognition Not Available", for: .disabled)
        }
    }
}
