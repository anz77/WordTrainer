//
//  BookViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 24.10.2020.
//

import UIKit

protocol SaveListNameDelegateProtocol: class {
    func saveName(_ name: String, for list: List)
}

class BookViewController: UIViewController {
    
    private var editModeEnabled: Bool = false {
        didSet {
            model.cleanListsForDeleting()
            editButton.setTitle(editModeEnabled ?  "Save" : "Edit", for: .normal)
            editButton.setImage(editModeEnabled ?  UIImage.save : UIImage.edit, for: .normal)
            editButton.setBackgroundColor(editModeEnabled ? .systemGreen : .systemPurple)
            addOrDeleteButton.setTitle(editModeEnabled ?  "Delete" : "Add", for: .normal)
            addOrDeleteButton.setImage(editModeEnabled ? UIImage.trash : UIImage.plus, for: .normal)
            addOrDeleteButton.setBackgroundColor(editModeEnabled ? .systemRed : .systemTeal)
        }
    }
    private var emptyModeEnabled: Bool = true
    
    var model: BookModelProtocol
    
    lazy var titleLabel: UILabel = UILabel.makeLabel(text: "Word Trainer", fontSize: 40, textAlignment: .left, textColor: UIColor.systemGray)
    lazy var settingsButton: UIButton = UIButton.makeSystemButton(systemName: "gearshape.2.fill", target: self, action: #selector(settingsButtonTapped), tintColor: .systemGray3)
    lazy var addOrDeleteButton: ImagedButton = .makeImagedButton(title: "Add", fontSize: 25, image: UIImage.plus, color: .systemTeal, target: self, action: #selector(addOrDeleteButtonTapped))
    lazy var editButton: ImagedButton = .makeImagedButton(title: "Edit", fontSize: 25, image: UIImage.edit, color: .systemPurple, target: self, action: #selector(editOrSaveButtonTapped))
    lazy var collectionView: UICollectionView = UICollectionView.makeCollectionView(backgroundColor: UIColor.systemBackground)
    lazy var addButton: UIButton = UIButton.makeBorderedButton(title: "Add List", target: self, action: #selector(addButtonTapped))
    lazy var addNewListLabel: UILabel = UILabel.makeLabel(text: "YOU DON'T HAVE \n ANY LISTS NOW \n\n TAP \"ADD LIST\" \n BUTTON TO ADD \n NEW LIST", fontSize: 30, textAlignment: .center, textColor: UIColor(named: "customControlColor")!)
    lazy var emptyView: UIView = UIView.makeView()
    lazy var listsView: UIView = UIView.makeView()
    
    init(model: BookModel) {
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
        model.fetchLists()
        setupUI()
    }
}

extension BookViewController {
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.secondarySystemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        addNewListLabel.numberOfLines = 10
        
        view.addSubview(titleLabel)
        view.addSubview(settingsButton)
        view.addSubview(emptyView)
        view.addSubview(listsView)
        emptyView.addSubview(addButton)
        emptyView.addSubview(addNewListLabel)
        listsView.addSubview(addOrDeleteButton)
        listsView.addSubview(editButton)
        listsView.addSubview(collectionView)
        
        setLayout()
    }
    
    func setLayout() {
        
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.057).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.bounds.width * -0.1).isActive = true
        settingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        emptyView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        listsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        listsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        listsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        listsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        addButton.topAnchor.constraint(equalTo: emptyView.topAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalTo: emptyView.widthAnchor, multiplier: 0.8).isActive = true
        
        addNewListLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        addNewListLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        addNewListLabel.heightAnchor.constraint(equalTo: emptyView.heightAnchor, multiplier: 0.5).isActive = true
        addNewListLabel.widthAnchor.constraint(equalTo: emptyView.widthAnchor, multiplier: 1.0).isActive = true
        
        addOrDeleteButton.topAnchor.constraint(equalTo: listsView.topAnchor).isActive = true
        addOrDeleteButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        addOrDeleteButton.leadingAnchor.constraint(equalTo: listsView.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        addOrDeleteButton.widthAnchor.constraint(equalTo: listsView.widthAnchor, multiplier: 0.40).isActive = true
        
        editButton.topAnchor.constraint(equalTo: listsView.topAnchor).isActive = true
        editButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        editButton.trailingAnchor.constraint(equalTo: listsView.trailingAnchor, constant: view.bounds.width * -0.05).isActive = true
        editButton.widthAnchor.constraint(equalTo: listsView.widthAnchor, multiplier: 0.40).isActive = true
        
        collectionView.centerXAnchor.constraint(equalTo: listsView.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: addOrDeleteButton.bottomAnchor, constant: 70).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: listsView.bottomAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: listsView.widthAnchor, multiplier: 1.0).isActive = true
    }
    
}

extension BookViewController {
    
    @objc func addOrDeleteButtonTapped() {
        editModeEnabled ? performDeleting() : presentAddAlert()
    }
    
    @objc func addButtonTapped() {
        presentAddAlert()
    }
    
    @objc func editOrSaveButtonTapped() {
        editModeEnabled.toggle()
    }
    
    @objc func settingsButtonTapped() {
        goToSettingsViewController()
    }
    
}

extension BookViewController {
    
    func needsReload() {
        emptyModeEnabled = (model.listsCount() == 0)
        emptyView.isHidden = !emptyModeEnabled
        listsView.isHidden = emptyModeEnabled
        collectionView.reloadData()
    }
    
    private func performDeleting() {
        model.deleteLists()
        editModeEnabled = false
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
    
    func goToSettingsViewController() {
        let controller = ModulesBuilder.configureSettingsViewController(storageManager: model.modelsStorageManager())
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true) {}
    }
    
    func goToListControllerWith(list: List) {
        let controller = ModulesBuilder.configureListViewController(list: list, saveListNameDelegate: self, storageManager: model.modelsStorageManager())
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true) {}
    }
    
    func managePreparationForDeletingCellFor(indexPath: IndexPath) {
        model.managePreparationForDeleting(list: model.listForIndex(indexPath.row))
        let cell = collectionView.cellForItem(at: indexPath) as! BookCollectionViewCell
        model.configureItemWithIndex(indexPath.item) { [weak self] list, isPreparedForDeleting in
            cell.configure(with: list)
            guard let self = self else {return}
            cell.contentView.backgroundColor = self.editModeEnabled ? (isPreparedForDeleting ? UIColor.systemRed.withAlphaComponent(0.4) : UIColor.systemGreen.withAlphaComponent(0.4)) : UIColor.systemTeal.withAlphaComponent(0.4)
        }
    }
}


extension BookViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.listsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BookCollectionViewCell
        model.configureItemWithIndex(indexPath.item) { [weak self] list, isPreparedForDeleting in
            cell.configure(with: list)
            guard let self = self else {return}
            cell.contentView.backgroundColor = self.editModeEnabled ? (isPreparedForDeleting ? UIColor.systemRed.withAlphaComponent(0.4) : UIColor.systemGreen.withAlphaComponent(0.4)) : UIColor.systemTeal.withAlphaComponent(0.4)
        }
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
        collectionView.deselectItem(at: indexPath, animated: true)
        editModeEnabled ? managePreparationForDeletingCellFor(indexPath: indexPath) :
            goToListControllerWith(list: model.listForIndex(indexPath.item))
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
