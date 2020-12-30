//
//  PaddingLabel.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 28.12.2020.
//

import UIKit

class PaddingLabel: UILabel {

    var topInset: CGFloat = 10.0
    var bottomInset: CGFloat = 10.0
    var leftInset: CGFloat = 10.0
    var rightInset: CGFloat = 10.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

//    override var bounds: CGRect {
//        didSet {
//            // ensures this works within stack views if multi-line
//            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
//        }
//    }
    
    static func makeTextLabel(text: String, fontSize: CGFloat, backgroundColor: UIColor) -> PaddingLabel {
        let label = PaddingLabel()
        label.textAlignment = .center
        label.text = text
        label.clipsToBounds = true
        label.layer.cornerRadius = 30
        label.numberOfLines = 0
        label.backgroundColor = backgroundColor
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
