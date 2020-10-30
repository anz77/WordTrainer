//
//  ListTableViewCell.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 25.10.2020.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    var keyLabel = UILabel()
    var valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0))
    }
    
    func setupUI() {
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.secondarySystemFill
        
        keyLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        contentView.addSubview(keyLabel)
        keyLabel.translatesAutoresizingMaskIntoConstraints = false
        keyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width * 0.05).isActive = true
        keyLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
        keyLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
        keyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * -0.2).isActive = true
        
        contentView.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width * 0.05).isActive = true
        valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
        valueLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * 0.2).isActive = true
    }
    
    

}
