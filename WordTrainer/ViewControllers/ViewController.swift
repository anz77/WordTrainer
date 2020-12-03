//
//  ViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 23.10.2020.
//

import UIKit

class ViewController: UIViewController {
    
    var model: Model!
    
    lazy var getRawWordsButton = CustomButton.makeCustomButton(dynamicColor: .red, title: "Get from XML", target: self, action: #selector(search))
    lazy var saveButton = CustomButton.makeCustomButton(dynamicColor: .red, title: "save", target: self, action: #selector(storeToCOREDATA))
    lazy var cleanButton = CustomButton.makeCustomButton(dynamicColor: .red, title: "CLEAN", target: self, action: #selector(cleanCOREDATA))
    lazy var fetchButton = CustomButton.makeCustomButton(dynamicColor: .red, title: "fetch", target: self, action: #selector(fetch))
    lazy var goBackButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemYellow, title: "Go to Settings Menu", target: self, action: #selector(goBack))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ViewController {
    
    @objc func search() {
        model.getWordsFromXMLDict()
        print(#function)
    }
    
    @objc func storeToCOREDATA() {
        model.populatePersistentStorage()
        print(#function)
    }
 
    @objc func cleanCOREDATA() {
        model.fetchAndClean()
        print(#function)
    }
    
    @objc func goBack() {
        self.dismiss(animated: true) {}
        print(#function)
    }
    
    @objc func saveNewDict() {
        model.makeNewXMLDictionary()
        print(#function)
    }
    
    @objc func fetch() {
        model.fetchWord("about") { (result) in
            do {
                let words = try result.get()
                debugPrint(words)
            } catch {
                debugPrint("no such word")
            }
        }
    }
    
}

extension ViewController {
    
    private func setupUI() {
        
        self.view.backgroundColor = .green
        
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

