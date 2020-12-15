//
//  UITextField + MakeTextFieldEstencion.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 04.12.2020.
//

import UIKit

extension UITextField {
    
    static func makeTextField(placeholder: String, fontSize: CGFloat) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: fontSize)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
}
