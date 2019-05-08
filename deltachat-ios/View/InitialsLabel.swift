//
//  InitialsLabel.swift
//  deltachat-ios
//
//  Created by Bastian van de Wetering on 03.05.19.
//  Copyright © 2019 Jonas Reinsch. All rights reserved.
//

import UIKit

class InitialsLabel: UILabel {
  convenience init(name: String, color: UIColor, size: CGFloat) {
    self.init(size: size)
    set(name: name)
    set(color: color)
  }

  init(size: CGFloat) {
    super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
    textAlignment = NSTextAlignment.center
    textColor = UIColor.white
    adjustsFontSizeToFitWidth = true
    let initialsLabelCornerRadius = size / 2
    layer.cornerRadius = initialsLabelCornerRadius
    clipsToBounds = true
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(name: String) {
    text = Utils.getInitials(inputName: name)
  }

  func set(color: UIColor) {
    backgroundColor = color
  }
}
