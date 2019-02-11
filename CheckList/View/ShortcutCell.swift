//
//  ShortcutCell.swift
//  CheckList
//
//  Created by junwoo on 11/02/2019.
//  Copyright © 2019 samchon. All rights reserved.
//

import UIKit

class ShortcutCell: UITableViewCell {
  
  static let reuseIdentifier = "ShortcutCell"
  
  lazy var bulletTextField: UITextField = {
    let textField = UITextField()
    textField.delegate = self
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.textAlignment = .center
    textField.layer.borderWidth = 1
    return textField
  }()
  
  lazy var unCheckedTextField: UITextField = {
    let textField = UITextField()
    textField.delegate = self
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.textAlignment = .center
    textField.layer.borderWidth = 1
    return textField
  }()
  
  lazy var checkedTextField: UITextField = {
    let textField = UITextField()
    textField.delegate = self
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.textAlignment = .center
    textField.layer.borderWidth = 1
    return textField
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  func configure(shortcut: Shortcut) {
    bulletTextField.text = shortcut.bullet
    unCheckedTextField.text = shortcut.unChecked
    checkedTextField.text = shortcut.checked
    
    addSubview(stackView)
    
    stackView.addArrangedSubview(bulletTextField)
    stackView.addArrangedSubview(unCheckedTextField)
    stackView.addArrangedSubview(checkedTextField)
    
    stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    
  }
  
  public func getShortcut() -> Shortcut? {
    guard let bullet = bulletTextField.text, bullet.trimmingCharacters(in: .whitespaces).count > 0 else { return nil }
    guard let unChecked = unCheckedTextField.text, unChecked.trimmingCharacters(in: .whitespaces).count > 0 else { return nil }
    guard let checked = checkedTextField.text, checked.trimmingCharacters(in: .whitespaces).count > 0 else { return nil }
    return Shortcut(bullet: bullet, unChecked: unChecked, checked: checked)
  }
}

extension ShortcutCell: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let maxLength = 1
    guard let text = textField.text else { return true }
    let count = text.count + string.count - range.length
    return count <= maxLength
  }
}
