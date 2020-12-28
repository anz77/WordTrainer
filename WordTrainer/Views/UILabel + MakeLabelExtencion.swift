//
//  UILabel + MakeLabelExtencion.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 04.12.2020.
//

import UIKit

extension UILabel {
    
    static func makeLabel(text: String, fontSize: CGFloat, textAlignment: NSTextAlignment, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    
}
