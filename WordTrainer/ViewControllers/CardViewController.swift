//
//  CardViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 25.10.2020.
//

import UIKit

class CardViewController: UIViewController {
        
    var model: CardModelProtocol
    
    weak var editCardDelegate: EditCardProtocol?
    
    lazy var keyLabel: UILabel = UILabel.makeLabel(text: model.currentCard().word, fontSize: 40, textAlignment: .center, textColor: UIColor.systemGray)
    lazy var tableView: UITableView = UITableView.makeTableView(style: .insetGrouped, backgroundColor: UIColor.systemBackground)
    lazy var goBackButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemTeal, title: "Cancel", fontSize: 25, target: self, action: #selector(goBackButtonTapped))
    
    init(model: CardModel) {
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
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.scrollToRow(at: IndexPath(row: model.currentCard().defaultIndex, section: 0), at: UITableView.ScrollPosition.middle, animated: true)
    }
    
}

extension CardViewController {
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: "CardCell")
        
        tableView.estimatedRowHeight = 50
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        view.addSubview(keyLabel)
        view.addSubview(goBackButton)
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
        
        tableView.topAnchor.constraint(equalTo: keyLabel.bottomAnchor, constant: view.bounds.height * 0.01).isActive = true
        tableView.bottomAnchor.constraint(equalTo: goBackButton.topAnchor, constant: view.bounds.height * -0.05).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension CardViewController {
    @objc func goBackButtonTapped() {
        editCardDelegate?.editCardIfNeeded(card: model.currentCard())
        self.dismiss(animated: true) {}
    }
    
    func needsReload() {
        tableView.reloadData()
    }
}



extension CardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.setCardDefaultIndex(indexPath.row)
        tableView.reloadData()
    }
    
}

extension CardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cardValuesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardTableViewCell
        cell.contentView.backgroundColor = (indexPath.row == model.cardDefaultIndex()) ?  UIColor.systemOrange : UIColor.quaternarySystemFill
        cell.textLabel?.numberOfLines = 5
        model.configureItemWithIndex(indexPath.row) { string in
            cell.textLabel?.text = string
        }
        return cell
    }
}

