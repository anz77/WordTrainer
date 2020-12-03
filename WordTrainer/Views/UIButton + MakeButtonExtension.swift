//
//  UIButton + MakeButtonExtension.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 19.11.2020.
//

import UIKit

extension UIButton {
    
    static func makeButton(color: UIColor, title: String, target: Any, action: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = color
        button.setTitle(title, for: UIControl.State.normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(target, action: action, for: .touchUpInside)
        button.layer.cornerRadius = 20
        return button
    }
}
