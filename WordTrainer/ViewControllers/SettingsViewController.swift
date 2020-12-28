//
//  SettingsViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 23.10.2020.
//

import UIKit

protocol SettingsViewProtocol: class {
    //var model: SettingsModel {get set}
}

class SettingsViewController: UIViewController {
    
    var model: SettingsModel
    
    lazy var getRawWordsButton = CustomButton.makeCustomButton(dynamicColor: .red, title: "Get from XML", fontSize: 25, target: self, action: #selector(searchButtonTapped))
    lazy var saveButton = CustomButton.makeCustomButton(dynamicColor: .red, title: "save", fontSize: 25, target: self, action: #selector(storeToCOREDATAButtonTapped))
    lazy var cleanButton = CustomButton.makeCustomButton(dynamicColor: .red, title: "CLEAN", fontSize: 25, target: self, action: #selector(cleanCOREDATAButtonTapped))
    lazy var fetchButton = CustomButton.makeCustomButton(dynamicColor: .red, title: "fetch", fontSize: 25, target: self, action: #selector(fetchButtonTapped))
    lazy var goBackButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemYellow, title: "Go to Settings Menu", fontSize: 25, target: self, action: #selector(goBackButtonTapped))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(model: SettingsModel) {
        self.model = model
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SettingsViewController {
    
    private func setupUI() {
        
        self.view.backgroundColor = .green
        
        view.addSubview(getRawWordsButton)
        view.addSubview(saveButton)
        view.addSubview(cleanButton)
        view.addSubview(goBackButton)
        view.addSubview(fetchButton)
        
        setLayout()
    }
    
    func setLayout() {
        getRawWordsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getRawWordsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * -0.2).isActive = true
        getRawWordsButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        getRawWordsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.0).isActive = true
        saveButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        cleanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cleanButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.2).isActive = true
        cleanButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        cleanButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        goBackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        goBackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        goBackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fetchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.3).isActive = true
        fetchButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        fetchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }
    
}

extension SettingsViewController {
    
    @objc func searchButtonTapped() {
        model.getWordsFromXMLDict()
    }
    
    @objc func storeToCOREDATAButtonTapped() {
        model.populatePersistentStorage()
    }
 
    @objc func cleanCOREDATAButtonTapped() {
        model.fetchAndClean()
    }
    
    @objc func goBackButtonTapped() {
        dismiss(animated: true) {}
    }
    
    @objc func saveNewDictButtonTapped() {
        model.makeNewXMLDictionary()
    }
    
    @objc func fetchButtonTapped() {
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

extension SettingsViewController: SettingsViewProtocol {}
