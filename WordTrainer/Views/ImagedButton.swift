//
//  ImagedButton.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 20.12.2020.
//

import UIKit

class ImagedButton: UIButton {
    
    var dynamicColor: UIColor?
    
    var customImageView: UIImageView = UIImageView()
    var customTitleLabel: UILabel = UILabel()
        
    override var isHighlighted: Bool {
            get {
                super.isHighlighted
            }
            set {
                
                backgroundColor = newValue ? dynamicColor?.withAlphaComponent(0.3) : dynamicColor?.withAlphaComponent(0.5)
                super.isHighlighted = newValue
            }
        }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        customTitleLabel.text = title
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        customImageView.image = image?.withTintColor(UIColor(named: "customControlColor")!, renderingMode: .alwaysOriginal)
    }
    
    override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        customTitleLabel.textColor = color
    }
    
    func setBackgroundColor(_ color: UIColor?) {
        self.dynamicColor = color
        backgroundColor = self.dynamicColor?.withAlphaComponent(0.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(customImageView)
        addSubview(customTitleLabel)
        customImageView.isUserInteractionEnabled = false
        customTitleLabel.isUserInteractionEnabled = false
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        customImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.height / 2).isActive = true
        customImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        customImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        customImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        customTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: frame.height / -2).isActive = true
        customTitleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        customTitleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        customTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0))
    }
}

extension ImagedButton {
    static func makeImagedButton(title: String, fontSize: CGFloat, image: UIImage, color: UIColor, target: Any, action: Selector) -> ImagedButton {
        let button = ImagedButton()
        button.setBackgroundColor(color)
        button.setTitleColor(UIColor(named: "customControlColor"), for: UIControl.State.normal)
        button.setTitle(title, for: UIControl.State.normal)
        button.setImage(image, for: .normal)
        button.customTitleLabel.textAlignment = .right
        button.customTitleLabel.font = UIFont.systemFont(ofSize: fontSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(target, action: action, for: .touchUpInside)
        button.layer.cornerRadius = 20
        return button
    }
}
