//
//  SearchViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 26.10.2020.
//

import UIKit

class SearchViewController: UIViewController {
    
    var model: SearchModel
    
//    var searchedResults: [Word] = [] {
//        didSet {
//            UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
//        }
//    }
    
    lazy var tableView: UITableView = makeTableView()
    lazy var searchBar: UISearchBar = makeSearchBar()
    lazy var cancelButton: UIButton = makeCancelButton()

    init(model: SearchModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.view = self
        setupUI()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
        registerForKeyboardNotifications()
    }
    
    func configureNewCardViewController(card: Card, alreadyInList: Bool, storeCardDelegate: StoreCardDelegateProtocol, storageManager: StorageManagerProtocol) -> NewCardViewController {
        let cardModel = NewCardModel(card: card, storageManager: storageManager)
        cardModel.alreadyInList = alreadyInList
        cardModel.storeCardDelegate = storeCardDelegate
        let controller = NewCardViewController(model: cardModel)
        cardModel.view = controller
        return controller
    }
    
}

extension SearchViewController {
    @objc func cancel() {
        self.dismiss(animated: true) {}
    }
}


extension SearchViewController {
    
    private func makeTableView() -> UITableView{
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 40
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    private func makeSearchBar() -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.backgroundColor = UIColor.systemBackground
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }
    
    private func  makeCancelButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Cancel", for: UIControl.State.normal)
        button.setTitleColor(UIColor.systemBlue, for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancel), for: UIControl.Event.touchUpInside)
        return button
    }
    
    func setupUI() {
        
        view.backgroundColor = UIColor.systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")
        
        self.view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            searchBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
        
        self.view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            cancelButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
        
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.2),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}


// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newCard = model.makeCardFromFetchedWordWithIndex(indexPath.row, for: model.currentList)
        let controller = configureNewCardViewController(card: newCard, alreadyInList: model.cardCheckingDelegate?.checkCard(newCard) ?? false, storeCardDelegate: model, storageManager: model.storageManager)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true) {}
    }
    
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.fetchedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        cell.textLabel?.text = model.fetchedWords[indexPath.row].word
        return cell
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.searchWordInPersistentStorage(word: searchText)
    }
    
    
}

extension SearchViewController: SearchViewProtocol {
    func needsReload() {
        tableView.reloadData()
    }
}

extension SearchViewController {
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(aNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(aNotification: Notification) {
        let dictionaryInfo: [AnyHashable: Any] = aNotification.userInfo!
        let kbSize = dictionaryInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let contentInsets = UIEdgeInsets(top: -20.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        tableView.contentInset = contentInsets
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
    }

    @objc func keyboardWillBeHidden(aNotification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
}


