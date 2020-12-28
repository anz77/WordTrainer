//
//  SearchViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 26.10.2020.
//

import UIKit

class SearchViewController: UIViewController {
    
    var model: SearchModelProtocol
    
    weak var storeCardDelegate: StoreCardDelegateProtocol?
    weak var cardCheckingDelegate: CardCheckingProtocol?
    
    lazy var tableView: UITableView = UITableView.makeTableView(style: .grouped, backgroundColor: UIColor.systemBackground)
    lazy var searchBar: UISearchBar = UISearchBar.makeSearchBar(placeholder: "Search", style: .minimal, backgroundColor: UIColor.systemBackground)
    lazy var cancelButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemBlue.withAlphaComponent(0.5), title: "Cancel", fontSize: 20, target: self, action: #selector(cancelButtonTapped))

    init(model: SearchModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
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
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
        registerForKeyboardNotifications()
    }
    
}

extension SearchViewController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")
        
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 40
        
        view.addSubview(searchBar)
        view.addSubview(cancelButton)
        view.addSubview(tableView)
        
        setLayout()
    }
    
    func setLayout() {
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            searchBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            cancelButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.047)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.2),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SearchViewController {
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true) {}
    }
    
    func needsReload() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newCard = model.makeCardFromFetchedWordWithIndex(indexPath.row, for: model.currentList())
        let controller = ModulesBuilder.configureNewCardViewController(card: newCard, alreadyInList: self.cardCheckingDelegate?.checkCard(newCard) ?? false, storeCardDelegate: self)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true) {}
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.fetchedWordsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        model.configureItemWithIndex(indexPath.row) { word in
            cell.textLabel?.text = word.word
        }
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.searchWordInPersistentStorage(word: searchText)
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
        let contentInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
}

extension SearchViewController: StoreCardDelegateProtocol {
    func storeCard(_ card: Card) {
        storeCardDelegate?.storeCard(card)
    }
    
}


//    var searchedResults: [Word] = [] {
//        didSet {
//            UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
//        }
//    }
    
