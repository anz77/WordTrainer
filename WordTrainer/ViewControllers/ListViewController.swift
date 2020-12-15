//
//  ListViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 25.10.2020.
//

import UIKit

protocol ListViewProtocol: class {
    var model: ListModel {get set}
    func needsReload()
}

class ListViewController: UIViewController {
    
    var model: ListModel
    
    weak var saveListNameDelegate: SaveListNameDelegateProtocol?
    
    private var editTitleModeEnabled: Bool = false
    private var editModeEnabled: Bool = false
    private var emptyModeEnabled: Bool = true
    
    lazy var titleLabel: UILabel = UILabel.makeLabel(text: model.currentList.name, fontSize: 40, textAlignment: .left, textColor: UIColor.systemGray)
    lazy var titleTextField: UITextField = UITextField.makeTextField(placeholder: model.currentList.name, fontSize: 40)
    lazy var editTitleButton = UIButton.makeButton(color: UIColor.systemBackground, title: "Rename", target: self, action: #selector(rename))
    lazy var addOrDeleteButton: UIButton = UIButton.makeButton(color: UIColor.systemTeal.withAlphaComponent(0.4), title: "Add Word", target: self, action: #selector(addOrDelete))
    lazy var editButton: UIButton = UIButton.makeButton(color: UIColor.systemPurple.withAlphaComponent(0.4), title: "Edit", target: self, action: #selector(editOrSave))
    lazy var tableView: UITableView = UITableView.makeTableView(style: .plain, backgroundColor: UIColor.clear)
    lazy var addButton: UIButton = UIButton.makeBorderedButton(title: "Add card", target: self, action: #selector(add))
    lazy var goBackButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemYellow.withAlphaComponent(0.6), title: "Go back", fontSize: 20, target: self, action: #selector(goBack))
    lazy var trainButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemGreen.withAlphaComponent(0.6), title: "Train", fontSize: 20, target: self, action: #selector(train))
    
    lazy var addNewCardLabel: UILabel = makeBigLabel()

    
    lazy var emptyView: UIView = makeEmptyView()
    lazy var cardsView: UIView = makeCardsView()
        
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
    
}

extension ListViewController {
    
    @objc func editOrSave() {
        model.cardsForDeleting = []
        disableEditTitleMode()
        editModeEnabled ? disableEditMode() : enableEditMode()
        tableView.reloadData()
    }
    
    @objc func goBack() {
        self.dismiss(animated: true) {}
    }
    
    @objc func rename() {
        editTitleModeEnabled ? disableEditTitleMode() : enableEditTitleMode()
    }
    
    @objc func add() {
        addNewCard()
    }
    
    @objc func addOrDelete() {
        disableEditTitleMode()
        editModeEnabled ? model.deleteCards() : addNewCard()
    }
    
    @objc func train() {
        let controller = ModulesBuilder.configureSpeechViewController(cards: model.cards, storageManager: model.storageManager)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    private func enableEditTitleMode() {
        editTitleModeEnabled = true
        titleLabel.isHidden = true
        titleTextField.isHidden = false
        editTitleButton.setTitle("Cancel", for: UIControl.State.normal)
        titleTextField.becomeFirstResponder()
    }
    
    private func disableEditTitleMode() {
        editTitleModeEnabled = false
        titleLabel.isHidden = false
        titleTextField.isHidden = true
        editTitleButton.setTitle("Rename", for: UIControl.State.normal)
        titleTextField.resignFirstResponder()
    }
    
    private func enableEditMode() {
        editModeEnabled = true
        editButton.setTitle("Save", for: .normal)
        editButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.4)
        addOrDeleteButton.setTitle("Delete", for: .normal)
        addOrDeleteButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.4)
    }
    
    private func disableEditMode() {
        editModeEnabled = false
        editButton.setTitle("Edit", for: .normal)
        editButton.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.4)
        addOrDeleteButton.setTitle("Add Word", for: .normal)
        addOrDeleteButton.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.4)
    }
    
    public func addNewCard() {
        let controller = ModulesBuilder.configureSearchViewController(list: model.currentList, cardCheckingDelegate: self, storeCardDelegate: self, storageManager: model.storageManager)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func goToCardControllerWith(card: Card) {
        let controller = ModulesBuilder.configureCardViewController(card: card, editCardDelegate: self)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true) {}
    }
    
    func managePreparationForDeletingCellFor(indexPath: IndexPath) {
        let card = model.cards[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! ListTableViewCell
        let isPrepared = model.isPreparedForDeleting(card: card)
        isPrepared ? model.restoreCard(card: card) : model.prepareCardForDeleting(card: card)
        cell.contentView.backgroundColor = isPrepared ? UIColor.systemTeal.withAlphaComponent(0.4) : UIColor.systemRed.withAlphaComponent(0.4)
    }
    
}


extension ListViewController {
    
    func makeBigLabel() -> UILabel {
        let label = UILabel()
        label.text = "YOU DON'T HAVE \n ANY CARDS IN THIS LIST \n\n TAP \"ADD CARD\" \n BUTTON TO ADD \n NEW CARD"
        label.numberOfLines = 10
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeEmptyView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeCardsView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func setupUI() {
        
        //titleLabel.backgroundColor = .red
        
        view.backgroundColor = UIColor.systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "ListCell")
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        //tableView.separatorInset = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 5)
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 20
        tableView.indicatorStyle = .white

        titleTextField.delegate = self
        titleTextField.isHidden = false
        titleTextField.isHidden = true
      
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.057).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(titleTextField)
        titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.057).isActive = true
        titleTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(editTitleButton)
        editTitleButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        editTitleButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.057).isActive = true
        editTitleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.bounds.width * -0.05).isActive = true
        editTitleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        
        view.addSubview(goBackButton)
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        goBackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40).isActive = true
        goBackButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        
        view.addSubview(trainButton)
        trainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        trainButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40).isActive = true
        trainButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        trainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.bounds.width * -0.05).isActive = true
        
        view.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: goBackButton.topAnchor, constant: view.bounds.height * -0.03).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        emptyView.addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: emptyView.topAnchor).isActive = true
        addButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.057).isActive = true
        addButton.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalTo: emptyView.widthAnchor, multiplier: 0.8).isActive = true
        
        emptyView.addSubview(addNewCardLabel)
        addNewCardLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        addNewCardLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        addNewCardLabel.heightAnchor.constraint(equalTo: emptyView.heightAnchor, multiplier: 0.5).isActive = true
        addNewCardLabel.widthAnchor.constraint(equalTo: emptyView.widthAnchor).isActive = true
        
        view.addSubview(cardsView)
        cardsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        cardsView.bottomAnchor.constraint(equalTo: goBackButton.topAnchor, constant: view.bounds.height * -0.03).isActive = true
        cardsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cardsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        cardsView.addSubview(addOrDeleteButton)
        addOrDeleteButton.topAnchor.constraint(equalTo: cardsView.topAnchor).isActive = true
        addOrDeleteButton.widthAnchor.constraint(equalTo: cardsView.widthAnchor, multiplier: 0.40).isActive = true
        addOrDeleteButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        addOrDeleteButton.leadingAnchor.constraint(equalTo: cardsView.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        
        cardsView.addSubview(editButton)
        editButton.topAnchor.constraint(equalTo: cardsView.topAnchor).isActive = true
        editButton.widthAnchor.constraint(equalTo: cardsView.widthAnchor, multiplier: 0.40).isActive = true
        editButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        editButton.trailingAnchor.constraint(equalTo: cardsView.trailingAnchor, constant: view.bounds.width * -0.05).isActive = true
        
        cardsView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: addOrDeleteButton.bottomAnchor, constant: view.bounds.height * 0.01).isActive = true
        tableView.widthAnchor.constraint(equalTo: cardsView.widthAnchor, multiplier: 0.90).isActive = true
        tableView.centerXAnchor.constraint(equalTo: cardsView.centerXAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: cardsView.bottomAnchor).isActive = true
    }
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        editModeEnabled ? managePreparationForDeletingCellFor(indexPath: indexPath) : goToCardControllerWith(card: model.cards[indexPath.row])
    }
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        let card = model.cards[indexPath.row]
        cell.contentView.backgroundColor = editModeEnabled ? (model.isPreparedForDeleting(card: card) ? UIColor.systemRed.withAlphaComponent(0.4) : UIColor.systemTeal.withAlphaComponent(0.4)) : UIColor.systemTeal.withAlphaComponent(0.4)
        cell.contentView.layer.borderColor = UIColor.systemBackground.cgColor
        cell.configure(with: card)
        cell.selectionStyle = .none
        return cell
    }
}

extension ListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {return true}
        model.saveListName(text)
        saveListNameDelegate?.saveName(text, for: model.currentList)
        titleLabel.text = model.currentList.name
        textField.resignFirstResponder()
        textField.text = ""
        textField.placeholder = model.currentList.name
        disableEditTitleMode()
        return true
    }
}

extension ListViewController: ListViewProtocol {
    func needsReload() {
        disableEditMode()
        emptyModeEnabled = model.cards.isEmpty
        emptyView.isHidden = !emptyModeEnabled
        cardsView.isHidden = emptyModeEnabled
        tableView.reloadData()
    }
}

extension ListViewController: EditCardProtocol {
    func editCardIfNeeded(card: Card) {
        model.editCardIfNeeded(card: card)
    }
}

extension ListViewController: StoreCardDelegateProtocol {
    func storeCard(_ card: Card) {
        model.storeCard(card)
    }
}

extension ListViewController: CardCheckingProtocol {
    func checkCard(_ card: Card) -> Bool {
        model.checkCard(card)
    }
}
