//
//  BookViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 24.10.2020.
//

import UIKit

protocol BookViewProtocol: class {
    var model: BookModel {get set}
    func needsReload()
}

class BookViewController: UIViewController {
        
    private var editModeEnabled: Bool = false
    private var emptyModeEnabled: Bool = true
    
    var model: BookModel
    
    lazy var titleLabel: UILabel = UILabel.makeLabel(text: "Word Trainer", fontSize: 40, textAlignment: .left, textColor: UIColor.systemGray)
    lazy var settingsButton: UIButton = makeSettingsButton()
    lazy var addOrDeleteButton: UIButton = UIButton.makeButton(color: UIColor.systemTeal.withAlphaComponent(0.4), title: "Add List", target: self, action: #selector(addOrDelete))
    lazy var editButton: UIButton = UIButton.makeButton(color: UIColor.systemPurple.withAlphaComponent(0.3), title: "Edit", target: self, action: #selector(editOrSave))
    //lazy var goBackButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemTeal, title: "Go to Start Menu", fontSize: 25, target: self, action: #selector(goBack))
    lazy var collectionView: UICollectionView = UICollectionView.makeCollectionView(backgroundColor: UIColor.systemBackground)
    lazy var addButton: UIButton = UIButton.makeBorderedButton(title: "Add List", target: self, action: #selector(add))
    lazy var addNewListLabel: UILabel = makeBigLabel()
    
    lazy var emptyView: UIView = makeEmptyView()
    lazy var listsView: UIView = makeListsView()
    
    init(model: BookModel) {
        self.model = model
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.fetchLists()
        setupUI()
    }
    
}

extension BookViewController {
    
    private func enableEditMode() {
        editModeEnabled = true
        model.listsForDeleting = []
        editButton.setTitle("Save", for: .normal)
        editButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.4)
        addOrDeleteButton.setTitle("Delete", for: .normal)
        addOrDeleteButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.4)
    }
    
    private func disableEditMode() {
        editModeEnabled = false
        model.listsForDeleting = []
        editButton.setTitle("Edit", for: .normal)
        editButton.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.4)
        addOrDeleteButton.setTitle("Add List", for: .normal)
        addOrDeleteButton.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.4)
    }
    
    @objc func addOrDelete() {
        editModeEnabled ? model.deleteLists() : presentAddAlert()
    }
    
    @objc func add() {
        presentAddAlert()
    }
    
    func presentAddAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Add new List", message: "Please, enter name of your new List (it can be changed in List settings):", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { $0.placeholder = "New List" }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ in
            guard let textField = alertController.textFields?.first, let text = textField.text else { return}
            self.model.addNewList(name: text.isEmpty ? "New List" : text)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { _ in })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func editOrSave() {
        editModeEnabled ? disableEditMode() : enableEditMode()
        collectionView.reloadData()
    }
    
    @objc func goBack() {
        self.dismiss(animated: true) {}
    }
    
    @objc func settings() {
        let controller = ModulesBuilder.configurePreferencesController(storageManager: model.storageManager)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true) {}
    }
    
    func goToListControllerFor(indexPath: IndexPath) {
        
    }
    
}

extension BookViewController {
    
    func makeBigLabel() -> UILabel {
        let label = UILabel()
        label.text = "YOU DON'T HAVE \n ANY LISTS NOW \n\n TAP \"ADD LIST\" \n BUTTON TO ADD \n NEW LIST"
        label.numberOfLines = 10
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeSettingsButton() -> UIButton {
        let button = UIButton.systemButton(with: UIImage(systemName: "gearshape.2.fill")!, target: self, action: #selector(settings))
        button.tintColor = .systemGray3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func makeEmptyView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeListsView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.057).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        view.addSubview(settingsButton)
        settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.bounds.width * -0.1).isActive = true
        settingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
 
        view.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(listsView)
        listsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        listsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        listsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        listsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        emptyView.addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: emptyView.topAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalTo: emptyView.widthAnchor, multiplier: 0.8).isActive = true
        
        emptyView.addSubview(addNewListLabel)
        addNewListLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        addNewListLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        addNewListLabel.heightAnchor.constraint(equalTo: emptyView.heightAnchor, multiplier: 0.5).isActive = true
        addNewListLabel.widthAnchor.constraint(equalTo: emptyView.widthAnchor, multiplier: 1.0).isActive = true
        
        listsView.addSubview(addOrDeleteButton)
        addOrDeleteButton.topAnchor.constraint(equalTo: listsView.topAnchor).isActive = true
        addOrDeleteButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        addOrDeleteButton.leadingAnchor.constraint(equalTo: listsView.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        addOrDeleteButton.widthAnchor.constraint(equalTo: listsView.widthAnchor, multiplier: 0.40).isActive = true
        
        listsView.addSubview(editButton)
        editButton.topAnchor.constraint(equalTo: listsView.topAnchor).isActive = true
        editButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        editButton.trailingAnchor.constraint(equalTo: listsView.trailingAnchor, constant: view.bounds.width * -0.05).isActive = true
        editButton.widthAnchor.constraint(equalTo: listsView.widthAnchor, multiplier: 0.40).isActive = true
        
        listsView.addSubview(collectionView)
        collectionView.centerXAnchor.constraint(equalTo: listsView.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: addOrDeleteButton.bottomAnchor, constant: 70).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: listsView.bottomAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: listsView.widthAnchor, multiplier: 1.0).isActive = true
    }
    
}

extension BookViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BookCollectionViewCell
        cell.contentView.backgroundColor = editModeEnabled ? (model.isPreparedForDeleting(list: model.lists[indexPath.row]) ? UIColor.systemRed.withAlphaComponent(0.4) : UIColor.systemGreen.withAlphaComponent(0.4)) : UIColor.systemTeal.withAlphaComponent(0.4)
        let list = model.lists[indexPath.item]
        cell.configure(with: list)
        return cell
    }
    
}

extension BookViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.9, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !editModeEnabled {
            collectionView.deselectItem(at: indexPath, animated: true)
            let controller = ModulesBuilder.configureListViewController(list: model.lists[indexPath.row], saveListNameDelegate: self, storageManager: model.storageManager)
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true) {}
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! BookCollectionViewCell
            let isPrepared = model.isPreparedForDeleting(list: model.lists[indexPath.row])
            isPrepared ? model.restoreList(list: model.lists[indexPath.row]) : model.prepareListForDeleting(list: model.lists[indexPath.row])
            cell.contentView.backgroundColor = isPrepared ? UIColor.systemGreen.withAlphaComponent(0.4) : UIColor.systemRed.withAlphaComponent(0.4)
        }
    }
    
}


extension BookViewController: BookViewProtocol {
    func needsReload() {
        disableEditMode()
        emptyModeEnabled = model.lists.isEmpty
        emptyView.isHidden = !emptyModeEnabled
        listsView.isHidden = emptyModeEnabled
        collectionView.reloadData()
    }
}


extension BookViewController: SaveListNameDelegateProtocol {
    func saveName(_ name: String, for list: List) {
        model.saveName(name, for: list)
    }
}



// MARK: - MOVING ITEMS IN COLLECTIONVIEW

// IN VIEWDIDLOAD
//let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
//collectionView.addGestureRecognizer(longPressGesture)


// GESTURE METHOD
//    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
//        switch(gesture.state) {
//        case .began:
//            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { break}
//            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
//        case .changed:
//            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
//        case .ended:
//            collectionView.endInteractiveMovement()
//        default:
//            collectionView.cancelInteractiveMovement()
//        }
//    }


// UICollectionViewDelegateFlowLayout
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//            let temp = model.allLists.remove(at: sourceIndexPath.item)
//            model.allLists.insert(temp, at: destinationIndexPath.item)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        return editModeEnabled ? true : false
//    }
