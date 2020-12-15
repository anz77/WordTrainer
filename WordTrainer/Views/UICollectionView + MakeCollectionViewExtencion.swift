//
//  UICollectionView + MakeCollectionViewExtencion.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 04.12.2020.
//

import UIKit


extension UICollectionView {
    
    static func makeCollectionView(backgroundColor: UIColor) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
}
