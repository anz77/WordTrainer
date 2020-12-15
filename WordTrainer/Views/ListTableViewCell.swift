//
//  ListTableViewCell.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 25.10.2020.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    lazy var keyLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.contentMode = .topLeft
        label.font = UIFont.systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0))
    }
    
    func setupUI() {
        valueLabel.numberOfLines = 0
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemBackground.cgColor
        contentView.addSubview(keyLabel)
        contentView.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: keyLabel.topAnchor, constant: -10),
            contentView.trailingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 15),
            contentView.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor,constant: 10),
            contentView.leadingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -15),

            keyLabel.trailingAnchor.constraint(equalTo: valueLabel.trailingAnchor),
            keyLabel.bottomAnchor.constraint(equalTo: valueLabel.topAnchor, constant: -5),
            keyLabel.leadingAnchor.constraint(equalTo: valueLabel.leadingAnchor)
        ])
        
    }
    
    func configure(with card: Card) {
        keyLabel.text = card.word
        valueLabel.text = card.values[card.defaultIndex]
    }

}
