//
//  SpeechViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 26.10.2020.
//

import UIKit
import Speech


protocol SpeechRecognizerDelegate: class {
    var recordButton: UIButton { get set }
    var textView: UITextView { get set }
}

class SpeechViewController: UIViewController, SpeechRecognizerDelegate {
    
    var recognizer: Recognizer?
    
    lazy var recordButton: UIButton = makeRecordButton()
    lazy var textView: UITextView = makeTextView()
    
    lazy var goBackButton: CustomButton = makeCustomButton(dynamicColor: UIColor.systemYellow.withAlphaComponent(0.7), title: "Go to main Menu", action: #selector(goBack))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        recognizer = Recognizer()
        recognizer?.delegate = self
        recognizer?.set()
        setupUI()
        recordButton.isEnabled = false
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        recognizer?.configure()
    }
    
}

extension SpeechViewController {
    
    @objc func recordButtonTapped() {
        recognizer?.start()
    }
        
    @objc func goBack() {
        print(#function)
        self.dismiss(animated: true) {}
    }
}

extension SpeechViewController {
    
    func makeRecordButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Record", for: UIControl.State.normal)
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
    
    func makeCustomButton(dynamicColor: UIColor, title: String, action: Selector) -> CustomButton {
        let dynamicColor = dynamicColor
        let button = CustomButton(dynamicColor: dynamicColor)
        button.backgroundColor = dynamicColor
        button.setTitle(title, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        button.layer.cornerRadius = 20
        return button
    }
    
    func setupUI() {
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1).isActive = true
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(recordButton)
        recordButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        recordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
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
