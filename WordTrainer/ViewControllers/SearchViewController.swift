//
//  SearchViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 26.10.2020.
//

import UIKit

class SearchViewController: UIViewController {
    
    var model: Model
    
    var searchedResults: [Word] = [] {
        didSet {
            UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
        }
    }
    
    lazy var tableView: UITableView = makeTableView()
    lazy var searchBar: UISearchBar = makeSearchBar()
    lazy var cancelButton: UIButton = makeCancelButton()

    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")
        setupUI()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
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
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 100, right: 0)
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
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0)])
    }
}


// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        return cell
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.searchWordInPersistentStorage(word: searchText) { storedWords in
            self.searchedResults = storedWords
        }
    }
    
    
}
