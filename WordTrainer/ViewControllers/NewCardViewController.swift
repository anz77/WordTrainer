//
//  NewCardViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 30.11.2020.
//

import UIKit

class NewCardViewController: UIViewController {
        
    var model: NewCardModelProtocol
    weak var storeCardDelegate: StoreCardDelegateProtocol?
    
    lazy var keyLabel: UILabel = UILabel.makeLabel(text: model.currentCard().word, fontSize: 40, textAlignment: .center, textColor: UIColor.systemGray)
    lazy var tableView: UITableView = UITableView.makeTableView(style: .plain, backgroundColor: UIColor.systemBackground)
    lazy var goBackButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemTeal, title: "Cancel", fontSize: 25, target: self, action: #selector(goBackButtonTapped))
    lazy var addNewCardButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemBlue, title: "Add to list", fontSize: 25, target: self, action: #selector(storeCardButtonTapped))
    lazy var alreadyInListLabel: UILabel = UILabel.makeLabel(text: "This card is already in list", fontSize: 20, textAlignment: .center, textColor: UIColor.systemRed)
    
    init(model: NewCardModel) {
        self.model = model
        super.init(nibName: nil, bundle: .main)
        model.viewNeedsReload = { [weak self] in
            self?.needsReload()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: "Cell")
        setupUI()
    }
    
}

extension NewCardViewController {
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        alreadyInListLabel.isHidden = !model.isAlreadyInList()
        addNewCardButton.isHidden = model.isAlreadyInList()
        
        view.addSubview(keyLabel)
        view.addSubview(goBackButton)
        view.addSubview(addNewCardButton)
        view.addSubview(alreadyInListLabel)
        view.addSubview(tableView)
        
        setLayout()
    }
    
    func setLayout() {
        keyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        keyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.05).isActive = true
        keyLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        keyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        goBackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        goBackButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
        goBackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        addNewCardButton.bottomAnchor.constraint(equalTo: goBackButton.topAnchor, constant: view.bounds.height * -0.05).isActive = true
        addNewCardButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        addNewCardButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
        addNewCardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        alreadyInListLabel.bottomAnchor.constraint(equalTo: goBackButton.topAnchor, constant: view.bounds.height * -0.05).isActive = true
        alreadyInListLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        alreadyInListLabel.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
        alreadyInListLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: keyLabel.bottomAnchor, constant: view.bounds.height * 0.01).isActive = true
        tableView.bottomAnchor.constraint(equalTo: addNewCardButton.topAnchor, constant: view.bounds.height * -0.05).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension NewCardViewController {
    @objc func goBackButtonTapped() {
        self.dismiss(animated: true) {}
    }
    
    @objc func storeCardButtonTapped() {
        storeCardDelegate?.storeCard(model.currentCard())
        self.dismiss(animated: true) {}
    }
    
    func needsReload() {
        tableView.reloadData()
    }
}

extension NewCardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.setCardDefaultIndex(indexPath.row)
    }
    
}

extension NewCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cardValuesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CardTableViewCell
        cell.contentView.backgroundColor = (indexPath.row == model.cardDefaultIndex()) ?  UIColor.systemOrange : UIColor.quaternarySystemFill
        cell.textLabel?.numberOfLines = 5
        
        cell.textLabel?.text = model.cardValueWihtIndex(indexPath.row)
        return cell
    }
}
