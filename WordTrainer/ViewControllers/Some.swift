//
//  Some.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 05.12.2020.
//

import UIKit
import Speech


class SpeechVC: UIViewController {
    
    @IBOutlet weak var slabel: UILabel!
    @IBOutlet weak var sbutton: UIButton!
    
    let audioEngine = AVAudioEngine()
    let SpeechRecognizer : SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask:SFSpeechRecognitionTask?
    
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestSpeechAuthorization()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer , _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else { return }
        if !myRecognizer.isAvailable {
            return
        }
        recognitionTask = SpeechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.slabel.text = bestString
                
                var lastString : String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[bestString.startIndex..<indexTo])//.substring(from: indexTo)
                }
                print(lastString)
            } else if let error = error {
                print(error)
            }
        })
    }
    
    
    @IBAction func startAction(_ sender: Any) {
        if isRecording == true {
            audioEngine.stop()
            recognitionTask?.cancel()
            isRecording = false
            sbutton.backgroundColor = UIColor.gray
        } else {
            self.recordAndRecognizeSpeech()
            isRecording = true
            sbutton.backgroundColor = UIColor.red
        }
        
    }
    func cancelRecording() {
        audioEngine.stop()
        //if let node = audioEngine.inputNode {
            audioEngine.inputNode.removeTap(onBus: 0)
        //}
        recognitionTask?.cancel()
    }
    
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized :
                    self.sbutton.isEnabled = true
                case .denied :
                    self.sbutton.isEnabled = false
                    self.slabel.text = "User denied access to speech recognition"
                case .restricted :
                    self.sbutton.isEnabled = false
                    self.slabel.text = "Speech Recognition is restricted on this Device"
                case .notDetermined :
                    self.sbutton.isEnabled = false
                    self.slabel.text = "Speech Recognition not yet authorized"
                @unknown default:
                    fatalError()
                }
            }
            
        }
    }
}


