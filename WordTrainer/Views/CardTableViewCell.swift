//
//  CardTableViewCell.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 09.11.2020.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    
    //var valueLabel = UILabel()
    
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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10))
    }
    
    func setupUI() {
        //valueLabel.numberOfLines = 5

        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.systemFill.cgColor
        contentView.layer.borderWidth = 1
        
        //contentView.backgroundColor = UIColor.quaternarySystemFill
        textLabel?.font = UIFont.systemFont(ofSize: 18)

    }
    
    

}
