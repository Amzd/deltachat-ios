//
//  ContactCell.swift
//  TableViewTest
//
//  Created by Alla Reinsch on 26.04.18.
//  Copyright © 2018 Alla Reinsch. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    //Klasse initialisieren nachschauen
    let initialsLabel:UILabel = UILabel()
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    var darkMode: Bool = false {
        didSet {
            if darkMode {
                contentView.backgroundColor = UIColor.darkGray
                nameLabel.textColor = UIColor.white
                emailLabel.textColor = UIColor.white
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        //Init von der Superklasse aufrufen nachschauen
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //configure and layout initialsLabel
        let initialsLabelSize:CGFloat = 60
        let initialsLabelCornerRadius = initialsLabelSize/2
        let margin:CGFloat = 15
        initialsLabel.textAlignment = NSTextAlignment.center
        initialsLabel.textColor = UIColor.white
        initialsLabel.font = UIFont.systemFont(ofSize: 24)
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        initialsLabel.widthAnchor.constraint(equalToConstant: initialsLabelSize).isActive = true
        initialsLabel.heightAnchor.constraint(equalToConstant: initialsLabelSize).isActive = true
        initialsLabel.backgroundColor = UIColor.green
        
        initialsLabel.layer.cornerRadius = initialsLabelCornerRadius
        initialsLabel.clipsToBounds = true
        
        self.contentView.addSubview(initialsLabel)
        initialsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        initialsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        initialsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        
        let myStackView = UIStackView()
        myStackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(myStackView)
        myStackView.leadingAnchor.constraint(equalTo: initialsLabel.trailingAnchor, constant: margin).isActive = true
        myStackView.centerYAnchor.constraint(equalTo: initialsLabel.centerYAnchor).isActive = true
        myStackView.axis = .vertical
        myStackView.addArrangedSubview(nameLabel)
        myStackView.addArrangedSubview(emailLabel)
        
        emailLabel.font = UIFont.systemFont(ofSize: 14)
        emailLabel.textColor = UIColor.gray
    }
    
    
    func setColor(_ color: UIColor) {
        self.initialsLabel.backgroundColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




