//
//  New.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 07.12.2020.
//

import UIKit
import Speech


class SomeView: UIViewController {
    
    var outputText: ((String)->())?
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var microphoneImageView: UIImageView!
    @IBOutlet weak var tapButton: UIButton!
    
    private var listening = false
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
        speechRecognizer?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func askMicPermission(completion: @escaping (Bool, String) -> ()) {
        SFSpeechRecognizer.requestAuthorization { status in
            let message: String
            var granted = false
            
            switch status {
                case .authorized:
                    message = "Listening..."
                    granted = true
                    break
                case .denied:
                    message = "Access to speech recognition is denied by the user."
                    break
                case .restricted:
                    message = "Speech recognition is restricted."
                    break
                case .notDetermined:
                    message = "Speech recognition has not been authorized yet."
                    break
            @unknown default:
                fatalError()
            }
            completion(granted, message)
        }
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        askMicPermission(completion: { (granted, message) in
            DispatchQueue.main.async {
                if self.listening {
                    self.listening = false
                    self.microphoneImageView.image = UIImage(named: "Microphone")
                    if granted { self.stopListening() }
                } else {
                    self.listening = true
                    self.microphoneImageView.image = UIImage(named: "Microphone Filled")
                    self.noteLabel.text = message
                    if granted { self.startListening() }
                }
            }
        })
    }
    
//MARK: - STOP LISTENING
    private func stopListening() {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        
        self.recognitionRequest = nil
        self.recognitionTask = nil
    }
    
//MARK: - START LISTENING
    private func startListening() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            noteLabel.text = "An error occurred when starting audio session."
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if let result = result {
                self.outputText?(result.bestTranscription.formattedString)
                //self.noteLabel.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.noteLabel.text = "Tap to listen"
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            noteLabel.text = "An error occurred starting audio engine"
        }
    }
    

}

//MARK: - DELEGATE
extension SomeView: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        tapButton.isEnabled = available
        if available {
            // Prepare to listen
            listening = true
            noteLabel.text = "Tap to listen"
            viewTapped(tapButton!)
        } else {
            noteLabel.text = "Recognition is not available."
        }
    }
    
}
