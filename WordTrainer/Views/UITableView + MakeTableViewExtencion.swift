//
//  UITableView + MakeTableViewExtencion.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 04.12.2020.
//

import UIKit

extension UITableView {
    
    static func makeTableView(style: UITableView.Style, backgroundColor: UIColor) -> UITableView{
        let tableView = UITableView(frame: CGRect.zero, style: style)
        tableView.backgroundColor = backgroundColor
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
}
