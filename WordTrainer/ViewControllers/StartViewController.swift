//
//  StartViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 24.10.2020.
//

import UIKit

class StartViewController: UIViewController {
    
    var model: Model!
    
    lazy var settingsButton: CustomButton = makeCustomButton(dynamicColor: .systemTeal, title: "Lists Settings", action: #selector(goToSettings))
    lazy var startButton: CustomButton = makeCustomButton(dynamicColor: .systemGreen, title: "Start", action: #selector(start))
    lazy var someButton: CustomButton = makeCustomButton(dynamicColor: .systemYellow, title: "Some Button", action: #selector(doSome))
    
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
}

extension StartViewController {
    
    @objc func goToSettings() {
        print(#function)
        
        let controller = SettingsViewController(model: model)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @objc func start() {
        print(#function)
        let controller = SpeechViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @objc func doSome() {
        print(#function)
        let storageManager = StorageManager()
        let controller = ViewController(storageManager: storageManager)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}


extension StartViewController {
    
    func makeCustomButton(dynamicColor: UIColor, title: String, action: Selector) -> CustomButton {
        let dynamicColor = dynamicColor
        let button = CustomButton(dynamicColor: dynamicColor)
        button.backgroundColor = dynamicColor
        button.setTitle(title, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        button.layer.cornerRadius = 20
        return button
    }
    
    func setupUI() {
        
        view.addSubview(settingsButton)
        settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * -0.25).isActive = true
        settingsButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        settingsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        view.addSubview(startButton)
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.00).isActive = true
        startButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        view.addSubview(someButton)
        someButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        someButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.25).isActive = true
        someButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        someButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }
}
