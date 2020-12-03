//
//  CardViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 25.10.2020.
//

import UIKit


class CardViewController: UIViewController {
        
    var model: CardModel
    
    lazy var keyLabel: UILabel = makeKeyLabel()
    lazy var tableView: UITableView = makeTableView()
    lazy var goBackButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemTeal, title: "Cancel", target: self, action: #selector(goBack))
    
    init(model: CardModel) {
        self.model = model
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

extension CardViewController {
    @objc func goBack() {
        model.editCardIfNeeded()
        self.dismiss(animated: true) {}
    }
}

extension CardViewController {
    
    private func makeKeyLabel() -> UILabel {
        let label = UILabel()
        label.text = model.card.word
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
        label.textColor = UIColor.systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        view.addSubview(keyLabel)
        keyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        keyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.05).isActive = true
        keyLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        keyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        view.addSubview(goBackButton)
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        goBackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        goBackButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
        goBackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: keyLabel.bottomAnchor, constant: view.bounds.height * 0.01).isActive = true
        tableView.bottomAnchor.constraint(equalTo: goBackButton.topAnchor, constant: view.bounds.height * -0.05).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
}

extension CardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.card.defaultIndex = indexPath.row
        tableView.reloadData()
    }
    
}

extension CardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.card.values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CardTableViewCell
        cell.contentView.backgroundColor = (indexPath.row == model.card.defaultIndex) ?  UIColor.systemOrange : UIColor.quaternarySystemFill
        cell.textLabel?.numberOfLines = 5
        cell.textLabel?.text = model.card.values[indexPath.row]
        return cell
    }
    
}

extension CardViewController: CardViewProtocol {
    
}

