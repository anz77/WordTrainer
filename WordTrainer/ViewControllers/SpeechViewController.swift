//
//  SpeechViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 26.10.2020.
//

import UIKit
import Speech

protocol SpeechRecognitionManagerDelegate: class {
    var state: SpeachRecognitionState { get set }
    var text: String { get set }
    
    //var recordButton: UIButton { get set }
    //var textView: UITextView { get set }
}

class SpeechViewController: UIViewController, SpeechRecognitionManagerDelegate {
    
    var text: String = "" {
        didSet {
            self.textView.text = text
        }
    }
    
    var state: SpeachRecognitionState = .notDetermined {
        didSet {
            switch state {
            case .authorized:
                self.recordButton.isEnabled = true
            case .authDenied:
                self.recordButton.isEnabled = false
                self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
            case .authRestricted:
                self.recordButton.isEnabled = false
                self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
            case .authNotDetermined:
                self.recordButton.isEnabled = false
                self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
            case .recordingIsStopping:
                self.recordButton.isEnabled = false
                self.recordButton.setTitle("Stopping", for: .disabled)
            case .recordingStarted:
                self.recordButton.setTitle("Stop Recording", for: [])
            case .recordingNotAvailable:
                self.recordButton.setTitle("Recording Not Available", for: [])
            case .recognitionAvailable:
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start Recording", for: [])
            case .recognitionNotAvailable:
                self.recordButton.isEnabled = false
                self.recordButton.setTitle("Recognition Not Available", for: .disabled)
            default:
                break
            }
            //print(state)
        }
    }
    
    var recognitionManager: SpeechRecognitionManager?
    
    lazy var recordButton: UIButton = makeRecordButton()
    lazy var textView: UITextView = makeTextView()
    
    lazy var goBackButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemYellow, title: "Go to main Menu", target: self, action: #selector(goBack))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        recognitionManager = SpeechRecognitionManager()
        recognitionManager?.delegate = self
        setupUI()
        recordButton.isEnabled = false
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        recognitionManager?.configure()

    }
    
}

extension SpeechViewController {
    
    @objc func recordButtonTapped() {
        recognitionManager?.start()
    }
        
    @objc func goBack() {
        self.dismiss(animated: true) {}
    }
}

extension SpeechViewController {
    
    func makeRecordButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Recording", for: UIControl.State.normal)
        return button
    }
    
    func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.layer.borderWidth = 5
        textView.isUserInteractionEnabled = false
        //textView.keyboardType = .alphabet
        textView.layer.borderColor = UIColor.systemFill.cgColor
        textView.font = UIFont.systemFont(ofSize: 30)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
    
    func setupUI() {
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1).isActive = true
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(recordButton)
        recordButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        recordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        
        view.addSubview(goBackButton)
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        goBackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        goBackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        goBackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
