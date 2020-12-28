//
//  ListViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 25.10.2020.
//

import UIKit

class ListViewController: UIViewController {
    
    var model: ListModelProtocol
    
    weak var saveListNameDelegate: SaveListNameDelegateProtocol?
    
    private var editTitleModeEnabled: Bool = false {
        didSet {
            titleLabel.isHidden = editTitleModeEnabled
            titleTextField.isHidden = !editTitleModeEnabled
            editTitleButton.setTitle(editTitleModeEnabled ? "Cancel" : "Rename", for: UIControl.State.normal)
            _ = editTitleModeEnabled ? titleTextField.becomeFirstResponder() : titleTextField.resignFirstResponder()
            model.cleanCardsForDeleting()
        }
    }
    
    private var editModeEnabled: Bool = false {
        didSet {
            editButton.setTitle(editModeEnabled ?  "Save" : "Edit", for: .normal)
            editButton.setImage(editModeEnabled ?  UIImage.save : UIImage.edit, for: .normal)
            editButton.setBackgroundColor(editModeEnabled ? .systemGreen : .systemPurple)
            addOrDeleteButton.setTitle(editModeEnabled ?  "Delete" : "Add", for: .normal)
            addOrDeleteButton.setImage(editModeEnabled ? UIImage.trash : UIImage.plus, for: .normal)
            addOrDeleteButton.setBackgroundColor(editModeEnabled ? .systemRed : .systemTeal)
        }
    }
    private var emptyModeEnabled: Bool = true
    
    lazy var titleLabel: UILabel = UILabel.makeLabel(text: model.currentList().name, fontSize: 40, textAlignment: .left, textColor: UIColor.systemGray)
    lazy var titleTextField: UITextField = UITextField.makeTextField(placeholder: model.currentList().name, fontSize: 40)
    lazy var editTitleButton = UIButton.makeButton(color: UIColor.systemBackground, title: "Rename", target: self, action: #selector(renameButtonTapped))
    lazy var addOrDeleteButton: ImagedButton = .makeImagedButton(title: "Add", fontSize: 25, image: UIImage.plus, color: .systemTeal, target: self, action: #selector(addOrDeleteButtonTapped))
    lazy var editButton: ImagedButton = .makeImagedButton(title: "Edit", fontSize: 25, image: UIImage.edit, color: .systemPurple, target: self, action: #selector(editOrSaveButtonTapped))
    lazy var tableView: UITableView = UITableView.makeTableView(style: .plain, backgroundColor: UIColor.clear)
    lazy var addButton: UIButton = UIButton.makeBorderedButton(title: "Add card", target: self, action: #selector(addButtonTapped))
    lazy var goBackButton: ImagedButton = .makeImagedButton(title: "Back", fontSize: 25, image: UIImage.backRow, color: .systemYellow, target: self, action: #selector(goBackButtonTapped))
    lazy var trainButton: ImagedButton = .makeImagedButton(title: "Train", fontSize: 25, image: UIImage.micCircle, color: .systemGreen, target: self, action: #selector(trainButtonTapped))
    lazy var addNewCardLabel: UILabel = UILabel.makeLabel(text: "YOU DON'T HAVE \n ANY CARDS IN THIS LIST \n\n TAP \"ADD CARD\" \n BUTTON TO ADD \n NEW CARD", fontSize: 30, textAlignment: .center, textColor: UIColor(named: "customControlColor")!)
    lazy var emptyView: UIView = UIView.makeView()
    lazy var cardsView: UIView = UIView.makeView()
        
    init(model: ListModel) {
        self.model = model
        super.init(nibName: nil, bundle: .main)
        self.model.viewNeedsReload = { [weak self] in
            self?.needsReload()
        }
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
    
    private func setupUI() {
        
        addNewCardLabel.numberOfLines = 10
                
        view.backgroundColor = UIColor.systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "ListCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 20
        tableView.indicatorStyle = .white

        titleTextField.delegate = self
        titleTextField.isHidden = false
        titleTextField.isHidden = true
      
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(editTitleButton)
        view.addSubview(goBackButton)
        view.addSubview(trainButton)
        view.addSubview(emptyView)
        emptyView.addSubview(addButton)
        emptyView.addSubview(addNewCardLabel)
        view.addSubview(cardsView)
        cardsView.addSubview(addOrDeleteButton)
        cardsView.addSubview(editButton)
        cardsView.addSubview(tableView)
        
        setLayout()
    }
    
    func setLayout() {
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.057).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.057).isActive = true
        titleTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        editTitleButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        editTitleButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.057).isActive = true
        editTitleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.bounds.width * -0.05).isActive = true
        editTitleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        goBackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40).isActive = true
        goBackButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        
        trainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        trainButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.40).isActive = true
        trainButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        trainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.bounds.width * -0.05).isActive = true
        
        emptyView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: goBackButton.topAnchor, constant: view.bounds.height * -0.03).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        addButton.topAnchor.constraint(equalTo: emptyView.topAnchor).isActive = true
        addButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.057).isActive = true
        addButton.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalTo: emptyView.widthAnchor, multiplier: 0.8).isActive = true
        
        addNewCardLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        addNewCardLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        addNewCardLabel.heightAnchor.constraint(equalTo: emptyView.heightAnchor, multiplier: 0.5).isActive = true
        addNewCardLabel.widthAnchor.constraint(equalTo: emptyView.widthAnchor).isActive = true
        
        cardsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        cardsView.bottomAnchor.constraint(equalTo: goBackButton.topAnchor, constant: view.bounds.height * -0.03).isActive = true
        cardsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cardsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        addOrDeleteButton.topAnchor.constraint(equalTo: cardsView.topAnchor).isActive = true
        addOrDeleteButton.widthAnchor.constraint(equalTo: cardsView.widthAnchor, multiplier: 0.40).isActive = true
        addOrDeleteButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        addOrDeleteButton.leadingAnchor.constraint(equalTo: cardsView.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        
        editButton.topAnchor.constraint(equalTo: cardsView.topAnchor).isActive = true
        editButton.widthAnchor.constraint(equalTo: cardsView.widthAnchor, multiplier: 0.40).isActive = true
        editButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        editButton.trailingAnchor.constraint(equalTo: cardsView.trailingAnchor, constant: view.bounds.width * -0.05).isActive = true
        
        tableView.topAnchor.constraint(equalTo: addOrDeleteButton.bottomAnchor, constant: view.bounds.height * 0.01).isActive = true
        tableView.widthAnchor.constraint(equalTo: cardsView.widthAnchor, multiplier: 0.90).isActive = true
        tableView.centerXAnchor.constraint(equalTo: cardsView.centerXAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: cardsView.bottomAnchor).isActive = true
    }
}

extension ListViewController {
    
    @objc func editOrSaveButtonTapped() {
        editTitleModeEnabled = false
        editModeEnabled.toggle()
    }
    
    @objc func goBackButtonTapped() {
        self.dismiss(animated: true) {}
    }
    
    @objc func renameButtonTapped() {
        editModeEnabled = false
        editTitleModeEnabled.toggle()
    }
    
    @objc func addButtonTapped() {
        goToSearchController()
        editTitleModeEnabled = false
    }
    
    @objc func addOrDeleteButtonTapped() {
        editModeEnabled ? performDeleting() : goToSearchController()
        editTitleModeEnabled = false
    }
    
    @objc func trainButtonTapped() {
        goToSpeachController()
    }
}

extension ListViewController {
    
    func needsReload() {
        emptyModeEnabled = (model.cardsCount() == 0)
        emptyView.isHidden = !emptyModeEnabled
        cardsView.isHidden = emptyModeEnabled
        tableView.reloadData()
    }
    
    private func performDeleting() {
        model.deleteCards()
        editModeEnabled = false
    }
    
    public func goToSearchController() {
        let controller = ModulesBuilder.configureSearchViewController(list: model.currentList(), cardCheckingDelegate: self, storeCardDelegate: self, storageManager: model.modelsStorageManager())
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true) {}
    }
    
    func goToSpeachController() {
        let controller = ModulesBuilder.configureSpeechViewController(cards: model.currentCards().shuffled(), storageManager: model.modelsStorageManager())
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true) {}
    }
    
    func goToCardControllerWith(card: Card) {
        editTitleModeEnabled = false
        let controller = ModulesBuilder.configureCardViewController(card: card, editCardDelegate: self)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true) {}
    }
    
    func managePreparationForDeletingCellFor(indexPath: IndexPath) {
        model.managePreparationForDeleting(card: model.cardForIndex(indexPath.row))
        let cell = tableView.cellForRow(at: indexPath) as! ListTableViewCell
        model.configureItemWithIndex(indexPath.row) { [weak self] card, preparedForDeleting in
            cell.configure(with: card)
            guard let self = self else {return}
            cell.contentView.backgroundColor = self.editModeEnabled ? (preparedForDeleting ? UIColor.systemRed.withAlphaComponent(0.4) : UIColor.systemGreen.withAlphaComponent(0.4)) : UIColor.systemTeal.withAlphaComponent(0.4)
        }
    }
    
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        editModeEnabled ? managePreparationForDeletingCellFor(indexPath: indexPath) : goToCardControllerWith(card: model.cardForIndex(indexPath.row))
    }
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cardsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        model.configureItemWithIndex(indexPath.row) { [weak self] card, preparedForDeleting in
            cell.configure(with: card)
            guard let self = self else {return}
            cell.contentView.backgroundColor = self.editModeEnabled ? (preparedForDeleting ? UIColor.systemRed.withAlphaComponent(0.4) : UIColor.systemGreen.withAlphaComponent(0.4)) : UIColor.systemTeal.withAlphaComponent(0.4)
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension ListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {return true}
        model.saveListName(text)
        saveListNameDelegate?.saveName(text, for: model.currentList())
        titleLabel.text = model.currentList().name
        textField.text = ""
        textField.placeholder = model.currentList().name
        editTitleModeEnabled = false
        return true
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
