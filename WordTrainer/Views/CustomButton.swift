//
//  CustomButton.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 24.10.2020.
//

import UIKit

class CustomButton: UIButton {
    
    var dynamicColor: UIColor?
    
    init(dynamicColor: UIColor) {
        super.init(frame: CGRect.zero)
        self.dynamicColor = dynamicColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
            get {
                return super.isHighlighted
            }
            set {
                if newValue {
                    backgroundColor = dynamicColor?.withAlphaComponent(0.5)
                }
                else {
                    backgroundColor = dynamicColor
                }
                super.isHighlighted = newValue
            }
        }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension CustomButton {
    static func makeCustomButton(dynamicColor: UIColor, title: String, fontSize: CGFloat, target: Any, action: Selector) -> CustomButton {
        //let dynamicColor = dynamicColor
        let button = CustomButton(dynamicColor: dynamicColor)
        button.backgroundColor = dynamicColor
        let color = UIColor(named: "customControlColor")
        button.setTitleColor(color, for: UIControl.State.normal)
        button.setTitle(title, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(target, action: action, for: .touchUpInside)
        button.layer.cornerRadius = 20
        return button
    }
}
