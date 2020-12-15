//
//  UISearchBar.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 04.12.2020.
//

import UIKit

extension UISearchBar {
    
    static func makeSearchBar(placeholder: String, style: UISearchBar.Style, backgroundColor: UIColor) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        //searchBar.searchTextField.font = UIFont.systemFont(ofSize: 15)
        searchBar.backgroundColor = backgroundColor
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = style
        searchBar.autocapitalizationType = .none
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }
}
