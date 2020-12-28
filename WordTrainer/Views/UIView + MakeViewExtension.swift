//
//  UIView + MakeViewExtension.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 16.12.2020.
//

import UIKit

extension UIView {
    
    static func makeView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
}
