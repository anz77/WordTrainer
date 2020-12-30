//
//  SpeechViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 26.10.2020.
//

import UIKit
import Speech

protocol SpeechRecognitionModelProtocol: class {
    var text: String { get set }
}

class SpeechViewController: UIViewController {
    
    var model: SpeechModelProtocol
    
    init(model: SpeechModel) {
        
        self.model = model
        
        super.init(nibName: nil, bundle: .main)
        
        model.viewSetReady = { [weak self] in
            self?.setReady()
        }
        model.viewSetRecording = { [weak self] in
            self?.setListen()
        }
        model.viewEnableControl = { [weak self] (enable: Bool) in
            enable ? self?.enableControl() : self?.disableControl()
        }
        model.viewDisplayRecognitionOutput = { [weak self] (string: String) in
            self?.displayRecognitionOutput(string)
        }
        model.viewDisplayQuestion = { [weak self] (string: String) in
            self?.displayQuestion(string)
        }
        model.viewDisplayAnswer = { [weak self] (string: String) in
            self?.displayAnswer(string)
        }
        model.viewDispalayEqual = { [weak self] (isEqual: Bool) in
            isEqual ? self?.displaySuccess() : self?.displayFailure()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var questionLabel: PaddingLabel = PaddingLabel.makeTextLabel(text: " ", fontSize: 30, backgroundColor: .systemFill)
    lazy var recognitionLabel: PaddingLabel = PaddingLabel.makeTextLabel(text: " ", fontSize: 35, backgroundColor: .systemFill)
    lazy var answerLabel: PaddingLabel = PaddingLabel.makeTextLabel(text: " ", fontSize: 30, backgroundColor: .clear)
    lazy var recordButton: ImagedButton = .makeImagedButton(title: "Denied", fontSize: 25, image: UIImage.micSlash, color: .systemGray, target: self, action: #selector(recordButtonTapped))
    lazy var goBackButton: ImagedButton = .makeImagedButton(title: "Back", fontSize: 25, image: UIImage.backRow, color: .systemYellow, target: self, action: #selector(goBackButtonTapped))
    lazy var nextButton: ImagedButton = .makeImagedButton(title: "Next", fontSize: 25, image: UIImage.nextRow, color: .systemBlue, target: self, action: #selector(nextButtonTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.secondarySystemBackground
        setupUI()
        disableControl()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        model.configure()
    }
    
}

extension SpeechViewController {
    
    func setupUI() {
        view.addSubview(questionLabel)
        view.addSubview(answerLabel)
        view.addSubview(recognitionLabel)
        view.addSubview(recordButton)
        view.addSubview(goBackButton)
        view.addSubview(nextButton)
        
        setLayout()
    }
    
    func setLayout() {
        questionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1).isActive = true
        questionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        questionLabel.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.2).isActive = true
        questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        answerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.3).isActive = true
        answerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        answerLabel.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.2).isActive = true
        answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        recognitionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.6).isActive = true
        recognitionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        recognitionLabel.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.2).isActive = true
        recognitionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        recordButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        recordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.3).isActive = true
        recordButton.setNeedsLayout()
        
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        goBackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40).isActive = true
        goBackButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        nextButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.bounds.width * -0.05).isActive = true
    }
}

extension SpeechViewController {
    
    @objc func recordButtonTapped() {
        model.action()
    }
        
    @objc func goBackButtonTapped() {
        model.cancelRecognition()
        self.dismiss(animated: true) {}
    }
    
    @objc func nextButtonTapped() {
        model.iterate()
    }
    
    @objc func listenButtonTapped() {
        model.speakWord()
    }
    
}

extension SpeechViewController {
    
    private func disableControl() {
        recordButton.backgroundColor = UIColor.systemGray
        recordButton.isEnabled = false
        recordButton.setImage(UIImage.micSlash, for: .normal)
        recordButton.setTitle("Denied", for: [])
    }
    
    private func enableControl() {
        recordButton.isEnabled = true
        recordButton.setBackgroundColor(UIColor.systemGreen)
        recordButton.setImage(UIImage.mic, for: .normal)
        recordButton.setTitle("Speak", for: [])
    }
    
    private func setListen() {
        recognitionLabel.backgroundColor = .systemFill
        recordButton.setBackgroundColor(UIColor.systemRed) //= UIColor.systemRed.withAlphaComponent(0.5)
        recordButton.setImage(UIImage.micFill, for: .normal)
        recordButton.setTitle("Stop", for: [])
    }
    
    private func setReady() {
        recordButton.setBackgroundColor(UIColor.systemGreen)
        recordButton.setImage(UIImage.mic, for: .normal)
        recordButton.setTitle("Speak", for: [])
    }
    
    private func displayRecognitionOutput(_ string: String) {
        recognitionLabel.text = string.lowercased()
    }
    
    private func displayQuestion(_ string: String) {
        questionLabel.text = string
        recognitionLabel.backgroundColor = .systemFill
    }
    
    private func displayAnswer(_ string: String) {
        answerLabel.text = string
    }
    
    private func displaySuccess() {
        recordButton.setBackgroundColor(.systemFill)
        recordButton.setTitle("Listen", for: .normal)
        recordButton.setImage(UIImage.megaphone, for: .normal)
        recognitionLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.5)
    }
    
    private func displayFailure() {
        recordButton.setBackgroundColor(.systemFill)
        recordButton.setTitle("Listen", for: .normal)
        recordButton.setImage(UIImage.megaphone, for: .normal)
        recognitionLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.5)
    }
}
