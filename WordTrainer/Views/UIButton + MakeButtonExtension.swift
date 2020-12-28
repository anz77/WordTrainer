//
//  UIButton + MakeButtonExtension.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 19.11.2020.
//

import UIKit

extension UIButton {
    
    static func makeButton(color: UIColor, title: String, fontSize: CGFloat = 20.0, target: Any, action: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = color
        button.setTitle(title, for: UIControl.State.normal)
        let color = UIColor(named: "customControlColor")
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(target, action: action, for: .touchUpInside)
        button.layer.cornerRadius = 20
        return button
    }
    
    static func makeBorderedButton(title: String, target: Any, action: Selector) -> UIButton {
        let button = UIButton(type: ButtonType.roundedRect)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 2
        //button.backgroundColor = UIColor.yellow
        button.setTitle(title, for: UIControl.State.normal)
        //button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(target, action: action, for: .touchUpInside)
        button.layer.cornerRadius = 20
        return button
    }
    
    static func makeSystemButton(systemName: String, target: Any, action: Selector, tintColor: UIColor) -> UIButton {
        let button = UIButton.systemButton(with: UIImage(systemName: systemName)!, target: target, action: action)
        button.tintColor = tintColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    
}
