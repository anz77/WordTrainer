//
//  SpeechViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 26.10.2020.
//

import UIKit
import Speech

protocol SpeechViewProtocol: class {
    var model: SpeechModel {get set}
    func disableControl()
    func enableControl()
    func setListen()
    func setReady()
    func setRecognitionOutput(_ string: String)
}

protocol SpeechRecognitionModelProtocol: class {
    var text: String { get set }
}

class SpeechViewController: UIViewController {
    
    var model: SpeechModel
    init(model: SpeechModel) {
        self.model = model
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var recordButton: UIButton = makeImagedButton(image: micCircle)//UIButton.makeButton(color: UIColor.systemGray, title: "Record", fontSize: 30.0, target: self, action: #selector(recordButtonTapped))
    lazy var textView: UITextView = makeTextView()
    
    lazy var goBackButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemYellow.withAlphaComponent(0.5), title: "Go back", fontSize: 25, target: self, action: #selector(goBack))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        setupUI()
        disableControl()
        //model.cofigureRecognitionService()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        model.cofigureRecognitionService()
    }
    
}

extension SpeechViewController {
    
    @objc func recordButtonTapped() {
        model.action()
    }
        
    @objc func goBack() {
        model.cancelRecognition()
        //model.recognitionService = nil
        self.dismiss(animated: true) {}
    }
}

extension SpeechViewController {
    
    var micCircle: UIImage {
        let symbol = UIImage(systemName: "mic.circle")//?.withTintColor(.red, renderingMode: .alwaysOriginal)
        //let symbol = UIImage(systemName:"rhombus")!
        
        //let scaleFactor = view.bounds.height
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    var micCircleFill: UIImage {
        let symbol = UIImage(systemName: "mic.circle.fill")//?.withTintColor(.red, renderingMode: .alwaysOriginal)
        //let symbol = UIImage(systemName:"rhombus")!
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
    var micSlash: UIImage {
        let symbol = UIImage(systemName: "mic.slash")//?.withTintColor(.red, renderingMode: .alwaysOriginal)
        //let symbol = UIImage(systemName:"rhombus")!
        let sz = CGSize(width: 200,height: 200)
        let r = UIGraphicsImageRenderer(size:sz)
        let image = r.image { _ in
            symbol?.draw(in:CGRect(origin:.zero, size:sz))
        }
        return image
    }
    
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
    
    func makeImagedButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .custom)
        button.imageView?.clipsToBounds = true
        button.setImage(image, for: .normal)
        //button.setTitle("Not available", for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(recordButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }
    
    func setupUI() {
        
        //recordButton.setTitleColor(UIColor(named: "customControlColor"), for: [])
        recordButton.layer.cornerRadius = view.bounds.height * 0.1

        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.4).isActive = true
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(recordButton)
        recordButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        recordButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.2).isActive = true
        
        view.addSubview(goBackButton)
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        goBackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        goBackButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
        goBackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension SpeechViewController: SpeechViewProtocol {
    
    func disableControl() {
        recordButton.backgroundColor = UIColor.systemGray
        recordButton.isEnabled = false
        recordButton.setImage(micSlash, for: .normal)
        //recordButton.setTitle("Not Available", for: [])
    }
    
    func enableControl() {
        recordButton.isEnabled = true
        recordButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.5)
        recordButton.setImage(micCircle, for: .normal)
        //recordButton.setTitle("Start", for: [])
    }
    
    func setListen() {
        recordButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.5)
        recordButton.setImage(micCircleFill, for: .normal)
        //recordButton.setTitle("Stop", for: [])
    }
    
    func setReady() {
        recordButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.5)
        recordButton.setImage(micCircle, for: .normal)
        //recordButton.setTitle("Start", for: [])
    }
    
    func setRecognitionOutput(_ string: String) {
        textView.text = string
    }
}
