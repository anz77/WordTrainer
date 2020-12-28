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
        model.viewSetListen = { [weak self] in
            self?.setListen()
        }
        model.viewEnableControl = { [weak self] in
            self?.enableControl()
        }
        model.viewDisableControl = { [weak self] in
            self?.disableControl()
        }
        model.viewSetRecognitionOutput = { [weak self] string in
            self?.setRecognitionOutput(string)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var recordButton: ImagedButton = .makeImagedButton(title: "Denied", fontSize: 25, image: UIImage.micSlash, color: .systemGray, target: self, action: #selector(recordButtonTapped))
    lazy var listenButton: ImagedButton = .makeImagedButton(title: "Listen", fontSize: 25, image: UIImage.megaphone, color: .systemGray, target: self, action: #selector(listenButtonTapped))
    lazy var textView: UITextView = makeTextView()
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
    
    
    
    func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .systemGray4
        textView.isUserInteractionEnabled = false
        //textView.keyboardType = .alphabet
        textView.font = UIFont.systemFont(ofSize: 30)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
    
    
    func setupUI() {

        //recordButton.layer.cornerRadius = view.bounds.height * 0.1
        
        recordButton.layer.cornerRadius = 20


        view.addSubview(textView)
        view.addSubview(listenButton)
        view.addSubview(recordButton)
        view.addSubview(goBackButton)
        view.addSubview(nextButton)
        
        setLayout()
    }
    
    func setLayout() {
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.4).isActive = true
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        listenButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        listenButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40).isActive = true
        listenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        listenButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.3).isActive = true
        
        recordButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        recordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40).isActive = true
        recordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.bounds.width * -0.05).isActive = true
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
        //model.recognitionService = nil
        self.dismiss(animated: true) {}
    }
    
    @objc func nextButtonTapped() {
        
    }
    
    @objc func listenButtonTapped() {
        
    }
    
}

extension SpeechViewController {
    
    func disableControl() {
        recordButton.backgroundColor = UIColor.systemGray
        recordButton.isEnabled = false
        recordButton.setImage(UIImage.micSlash, for: .normal)
        recordButton.setTitle("Denied", for: [])
    }
    
    func enableControl() {
        recordButton.isEnabled = true
        recordButton.setBackgroundColor(UIColor.systemGreen)
        recordButton.setImage(UIImage.mic, for: .normal)
        recordButton.setTitle("Speak", for: [])
    }
    
    func setListen() {
        recordButton.setBackgroundColor(UIColor.systemRed) //= UIColor.systemRed.withAlphaComponent(0.5)
        recordButton.setImage(UIImage.micFill, for: .normal)
        recordButton.setTitle("Stop", for: [])
    }
    
    func setReady() {
        recordButton.setBackgroundColor(UIColor.systemGreen)
        recordButton.setImage(UIImage.mic, for: .normal)
        recordButton.setTitle("Speak", for: [])
    }
    
    func setRecognitionOutput(_ string: String) {
        textView.text = string
    }
}
