//
//  ViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 23.10.2020.
//

import UIKit

class ViewController: UIViewController {
    
    var storageManager: StorageManager!
    
    lazy var getRawWordsButton = makeCustomButton(dynamicColor: .red, title: "Get from XML", action: #selector(search))
    
    lazy var saveButton = makeCustomButton(dynamicColor: .red, title: "save", action: #selector(storeToCOREDATA))
    
    lazy var cleanButton = makeCustomButton(dynamicColor: .red, title: "CLEAN", action: #selector(cleanCOREDATA))
    
    lazy var fetchButton = makeCustomButton(dynamicColor: .red, title: "fetch", action: #selector(fetch))
    
    lazy var goBackButton: CustomButton = makeCustomButton(dynamicColor: UIColor.systemYellow.withAlphaComponent(0.7), title: "Go to Settings Menu", action: #selector(goBack))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        setupUI()
    }
    
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ViewController {
    
    @objc func search() {
        storageManager.getWordsFromXMLDict()
        print(#function)
    }
    
    @objc func storeToCOREDATA() {
        storageManager.storeWordsToPersistentStorage()
        print(#function)
    }
 
    @objc func cleanCOREDATA() {
        storageManager.fetchAndClean()
        print(#function)
    }
    
    @objc func goBack() {
        self.dismiss(animated: true) {}
        print(#function)
    }
    
    @objc func saveNewDict() {
        storageManager.makeNewXMLDictionary()
        print(#function)
    }
    
    @objc func fetch() {
        storageManager.fetchWord("about")
        print(#function)
    }
    
    
}

extension ViewController {
    
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
    
    private func setupUI() {
        view.addSubview(getRawWordsButton)
        getRawWordsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getRawWordsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * -0.2).isActive = true
        getRawWordsButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        getRawWordsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        view.addSubview(saveButton)
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.0).isActive = true
        saveButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        view.addSubview(cleanButton)
        cleanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cleanButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.2).isActive = true
        cleanButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        cleanButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        view.addSubview(goBackButton)
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        goBackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        goBackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        goBackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        
        view.addSubview(fetchButton)
        fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fetchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.3).isActive = true
        fetchButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        fetchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }
    
}

