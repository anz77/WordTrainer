//
//  StartViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 24.10.2020.
//

import UIKit

protocol StartViewProtocol: class {
    var model: StartModel {get set}
}

class StartViewController: UIViewController {
    
    var model: StartModel
    
    lazy var settingsButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: .systemTeal, title: "Your Lists", fontSize: 55, target: self, action: #selector(goToSettings))
    lazy var startButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: .systemGreen, title: "Start", fontSize: 55, target: self, action: #selector(start))
    //lazy var someButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: .systemYellow, title: "Some Button", fontSize: 45, target: self, action: #selector(doSome))
    
    init(model: StartModel) {
        self.model = model
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray
        setupUI()
    }
}

extension StartViewController {
    
    @objc func goToSettings() {
        let controller = ModulesBuilder.configureBookViewController(storageManager: model.storageManager)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @objc func start() {
        let controller = ModulesBuilder.configureSpeechViewController(cards: [], storageManager: model.storageManager)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @objc func doSome() {
        let controller = ModulesBuilder.configurePreferencesController(storageManager: model.storageManager)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}


extension StartViewController {
    
    func setupUI() {
        
        view.addSubview(settingsButton)
        settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * -0.17).isActive = true
        settingsButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        settingsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        view.addSubview(startButton)
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.17).isActive = true
        startButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
//        view.addSubview(someButton)
//        someButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        someButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.25).isActive = true
//        someButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
//        someButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }
}

extension StartViewController: StartViewProtocol {}
