//
//  ListViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 25.10.2020.
//

import UIKit

class ListViewController: UIViewController {
    
    var model: ListModel
    
    var editTitleModeEnabled: Bool = false {
        didSet {
            titleLabel.isHidden = editTitleModeEnabled
            titleTextField.isHidden = !editTitleModeEnabled
            editTitleButton.setTitle(editTitleModeEnabled ? "Cancel" : "Rename", for: UIControl.State.normal)
        }
    }
    
    lazy var titleLabel: UILabel = makeTitleLabel()
    lazy var titleTextField: UITextField = makeTitleTextField()
    
    lazy var editTitleButton = UIButton.makeButton(color: UIColor.systemBackground, title: "Rename", target: self, action: #selector(rename))
    lazy var addNewWordButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemBlue, title: "Add new word", target: self, action: #selector(addNewWord))
    lazy var tableView: UITableView = makeTableView()
    lazy var goBackButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemYellow, title: "Go to Settings Menu", target: self, action: #selector(goBack))
        
    init(model: ListModel) {
        self.model = model
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.fetchCards()
        setupUI()
    }
    
    func configereCardViewController(card: Card, storageManager: StorageManagerProtocol) -> CardViewController {
        let cardModel = CardModel(card: card, storageManager: model.storageManager)
        cardModel.editCardDelegate = model
        let controller = CardViewController(model: cardModel)
        cardModel.view = controller
        return controller
    }
    
    func configereSearchViewController(list: List, cardCheckingDelegate: CardCheckingProtocol, storeCardDelegate: StoreCardDelegateProtocol, storageManager: StorageManagerProtocol) -> SearchViewController {
        let searchModel = SearchModel(currentList: list, storageManager: storageManager)
        searchModel.cardCheckingDelegate = cardCheckingDelegate
        searchModel.storeCardDelegate = storeCardDelegate
        let controller = SearchViewController(model: searchModel)
        return controller
    }
    
}

extension ListViewController {
    
    @objc func goBack() {
        self.dismiss(animated: true) {}
    }
    
    @objc func rename() {
        editTitleModeEnabled.toggle()
                
        if editTitleModeEnabled {
            titleTextField.becomeFirstResponder()
        } else {
            titleTextField.text = ""
            titleTextField.resignFirstResponder()
        }
    }
    
    @objc func addNewWord() {
        let controller = configereSearchViewController(list: model.currentList, cardCheckingDelegate: model, storeCardDelegate: model, storageManager: model.storageManager)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}


extension ListViewController {
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = model.currentList.name
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = UIColor.systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeTitleTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = model.currentList.name
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }

    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.insetGrouped)
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 100, right: 0)
        tableView.backgroundColor = UIColor.systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        titleTextField.delegate = self
        titleTextField.isHidden = false
        titleTextField.isHidden = true
      
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.1).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(titleTextField)
        titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.1).isActive = true
        titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(editTitleButton)
        editTitleButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        editTitleButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        editTitleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.bounds.height * -0.05).isActive = true
        editTitleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        
        view.addSubview(addNewWordButton)
        addNewWordButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: view.bounds.height * 0.01).isActive = true
        addNewWordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        addNewWordButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        addNewWordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.separatorInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.topAnchor.constraint(equalTo: addNewWordButton.bottomAnchor, constant: view.bounds.height * 0.01).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.00).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.1).isActive = true
        
        view.addSubview(goBackButton)
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        goBackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        goBackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        goBackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * 0.07
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let controller = configereCardViewController(card: model.cards[indexPath.row], storageManager: model.storageManager)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true) {}
    }
    
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.contentView.layer.cornerRadius = 10
        let card = model.cards[indexPath.row]
        cell.keyLabel.text = card.word
        cell.valueLabel.text = card.values[card.defaultIndex]
        return cell
    }
}


extension ListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {return true}
        model.saveListName(text)
        //model.currentList.name = text
        titleLabel.text = model.currentList.name
        textField.resignFirstResponder()
        titleTextField.text = ""
        textField.placeholder = model.currentList.name
        editTitleModeEnabled = false
        return true
    }
}

extension ListViewController: ListViewProtocol {
    func needsReload() {
        tableView.reloadData()
    }
}
