//
//  SettingsCollectionViewCell.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 25.10.2020.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel = UILabel()
    
//    var preparedForRemoving: Bool = false {
//        didSet {
//            print(preparedForRemoving)
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        //contentView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.4)
        contentView.layer.cornerRadius = 20
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        
        contentView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }
    
    
}
