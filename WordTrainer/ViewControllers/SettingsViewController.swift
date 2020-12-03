//
//  SettingsViewController.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 24.10.2020.
//

import UIKit

class SettingsViewController: UIViewController {
        
    var editModeEnabled: Bool = false
    
    var model: SettingsModel
    
    lazy var titleLabel: UILabel = makeTitleLabel()
    lazy var addOrDeleteButton: UIButton = UIButton.makeButton(color: UIColor.systemBlue.withAlphaComponent(0.3), title: "Add List", target: self, action: #selector(addOrDelete))
    lazy var editButton: UIButton = UIButton.makeButton(color: UIColor.systemPurple.withAlphaComponent(0.3), title: "Edit", target: self, action: #selector(editOrSave))
    lazy var goBackButton: CustomButton = CustomButton.makeCustomButton(dynamicColor: UIColor.systemTeal, title: "Go to Start Menu", target: self, action: #selector(goBack))
    lazy var collectionView: UICollectionView = makeWordSetsCollectionView()
    
    init(model: SettingsModel) {
        self.model = model
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.fetchLists()
        setupUI()
        //let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        //collectionView.addGestureRecognizer(longPressGesture)
    }
    
    func configureListViewController(list: List, storageManager: StorageManagerProtocol) -> ListViewController {
        let listModel = ListModel(currentList: list, storageManager: storageManager)
        listModel.saveListNameDelegate = model
        let controller = ListViewController(model: listModel)
        listModel.view = controller
        return controller
    }
    
}

extension SettingsViewController {
    
    @objc func addOrDelete() {
        editModeEnabled ? model.deleteLists() : presentAddAlert()
    }
    
    func presentAddAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Add new List", message: "Please, enter name of your new List (it can be changed in List settings):", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "New List"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action : UIAlertAction!) -> Void in
            let textField = alertController.textFields![0] as UITextField
            print(textField.text!)
            
            var listName = "New List"
            if let text = textField.text {
                if !text.isEmpty {
                    listName = text
                }
            }
            self.model.addNewList(name: listName)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func editOrSave() {
        editModeEnabled.toggle()
        model.listsForDeleting = []
        editButton.setTitle(editModeEnabled ? "Save" : "Edit", for: .normal)
        editButton.backgroundColor = editModeEnabled ? UIColor.systemGreen.withAlphaComponent(0.5) : UIColor.systemPurple.withAlphaComponent(0.3)
        addOrDeleteButton.setTitle(editModeEnabled ? "Delete" : "Add List", for: .normal)
        addOrDeleteButton.backgroundColor = editModeEnabled ? UIColor.systemRed.withAlphaComponent(0.5) : UIColor.systemBlue.withAlphaComponent(0.3)
        collectionView.reloadData()
    }
    
    @objc func goBack() {
        self.dismiss(animated: true) {}
    }
    
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
    
}

extension SettingsViewController {
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "Your Lists"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
        label.textColor = UIColor.systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeWordSetsCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        view.addSubview(addOrDeleteButton)
        addOrDeleteButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        addOrDeleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addOrDeleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.1).isActive = true
        addOrDeleteButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35).isActive = true
        
        view.addSubview(editButton)
        editButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.bounds.width * -0.1).isActive = true
        editButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35).isActive = true
        
        view.addSubview(goBackButton)
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * -0.05).isActive = true
        goBackButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        goBackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        goBackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SettingsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: addOrDeleteButton.bottomAnchor, constant: 30).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: goBackButton.topAnchor, constant: view.bounds.height * -0.05).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
    }
    
}

extension SettingsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.allLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SettingsCollectionViewCell
        cell.contentView.backgroundColor = editModeEnabled ? (model.isPreparedForDeleting(list: model.allLists[indexPath.row]) ? UIColor.systemRed.withAlphaComponent(0.2) : UIColor.systemPurple.withAlphaComponent(0.2)) : UIColor.systemYellow.withAlphaComponent(0.4)
        cell.label.text = model.allLists[indexPath.item].name
        return cell
    }
    
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.8, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !editModeEnabled {
            collectionView.deselectItem(at: indexPath, animated: true)
            
            let controller = configureListViewController(list: model.allLists[indexPath.row], storageManager: model.storageManager)
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true) {
                collectionView.reloadData()
            }
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! SettingsCollectionViewCell
            
            if model.isPreparedForDeleting(list: model.allLists[indexPath.row]) {
                model.restoreList(list: model.allLists[indexPath.row])
                cell.contentView.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.2)
            } else {
                model.prepareListForDeleting(list: model.allLists[indexPath.row])
                cell.contentView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
            }
        }
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//            let temp = model.allLists.remove(at: sourceIndexPath.item)
//            model.allLists.insert(temp, at: destinationIndexPath.item)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        return editModeEnabled ? true : false
//    }
}


extension SettingsViewController: SettingsViewProtocol {
    func needsReload() {
        collectionView.reloadData()
    }
}

