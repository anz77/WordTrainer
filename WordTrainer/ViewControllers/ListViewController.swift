//
//  ListViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 25.10.2020.
//

import UIKit

class ListViewController: UIViewController {
    
    var model: Model
    let listIndex: Int
    
    var editTitleModeEnabled: Bool = false {
        didSet {
            titleLabel.isHidden = editTitleModeEnabled
            titleTextField.isHidden = !editTitleModeEnabled
            editTitleButton.setTitle(editTitleModeEnabled ? "Cancel" : "Rename", for: UIControl.State.normal)
        }
    }
    
    lazy var titleLabel: UILabel = makeTitleLabel()
    lazy var titleTextField: UITextField = makeTitleTextField()
    
    lazy var editTitleButton = makeButton(color: UIColor.systemBackground, title: "Rename", action: #selector(rename))
    
    lazy var addNewWordButton = makeCustomButton(dynamicColor: UIColor.systemBlue, title: "Add new word", action: #selector(addNewWord))
    
    lazy var tableView: UITableView = makeTableView()
    
    lazy var goBackButton: CustomButton = makeCustomButton(dynamicColor: UIColor.systemYellow.withAlphaComponent(0.7), title: "Go to Settings Menu", action: #selector(goBack))
        
    init(model: Model, listIndex: Int) {
        self.model = model
        self.listIndex = listIndex
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        titleTextField.delegate = self
        titleTextField.isHidden = false
        titleTextField.isHidden = true
        setupUI()
    }
    
    
    
}

extension ListViewController {
    
    @objc func goBack() {
        print(#function)
        self.dismiss(animated: true) {}
    }
    
    @objc func rename() {
        print(#function)
        editTitleModeEnabled.toggle()
        if editTitleModeEnabled {
            titleTextField.becomeFirstResponder()
        } else {
            titleTextField.resignFirstResponder()
            titleTextField.text = ""
        }
    }
    
    @objc func addNewWord() {
        let controller = SearchViewController(model: model)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}


extension ListViewController {
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = model.wordListsArray[listIndex].name
        label.font = UIFont.systemFont(ofSize: 30)
        //label.textAlignment = .center
        label.textColor = UIColor.systemGray
        //label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeTitleTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = model.wordListsArray[listIndex].name
        textField.font = UIFont.systemFont(ofSize: 30)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    private func makeButton(color: UIColor, title: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = color
        button.setTitle(title, for: UIControl.State.normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        button.layer.cornerRadius = 20
        return button
    }
    
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
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.insetGrouped)
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 100, right: 0)
        tableView.backgroundColor = UIColor.systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    private func setupUI() {
      
        view.addSubview(titleLabel)
        //titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.1).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(titleTextField)
        //titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
    }
    
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.wordListsArray[listIndex].wordCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        //cell.contentView.backgroundColor = UIColor.secondarySystemFill
        cell.contentView.layer.cornerRadius = 10
        cell.keyLabel.text = model.wordListsArray[listIndex].wordCards[indexPath.row].key
        cell.valueLabel.text = model.wordListsArray[listIndex].wordCards[indexPath.row].word?.values.first
        return cell
    }
}


extension ListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {return true}
        model.wordListsArray[listIndex].name = text
        titleLabel.text = model.wordListsArray[listIndex].name
        
        textField.resignFirstResponder()
        titleTextField.text = ""
        textField.placeholder = model.wordListsArray[listIndex].name
        editTitleModeEnabled = false
        return true
    }
}
