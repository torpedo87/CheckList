//
//  TableViewCell.swift
//  CheckList
//
//  Created by junwoo on 07/02/2019.
//  Copyright © 2019 samchon. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate: class {
  func didEnterAtListMode(indexPath: IndexPath, text: String, isListed: Bool, isChecked: Bool)
  func didSizeChanged()
}

class TableViewCell: UITableViewCell {
  static let reuseIdentifier = "TableViewCell"
  weak var delegate: TableViewCellDelegate?
  
  var indexPath: IndexPath!
  var tableRow: TableRow!
  var bullet: String = "-"
  var checked: String = "v"
  var unChecked: String = "ㅁ"
  
  private lazy var customTextView: CustomTextView = {
    let textView = CustomTextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.backgroundColor = UIColor.yellow
    textView.isScrollEnabled = false
    textView.delegate = self
    return textView
  }()
  
  private lazy var button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor.green
    button.addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
    return button
  }()
  
  func configure(indexPath: IndexPath, tableRow: TableRow) {
    selectionStyle = .none
    self.indexPath = indexPath
    self.tableRow = tableRow
    
    addSubview(button)
    addSubview(customTextView)
    setListMode(listMode: tableRow.isListed)

    if tableRow.isListed {
      button.setTitle(bullet, for: UIControl.State.normal)
    }
    
    button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
    button.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    button.sizeToFit()
    customTextView.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 5).isActive = true
    customTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
    customTextView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    customTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    
    customTextView.becomeFirstResponder()
  }
  
  func setListMode(listMode: Bool) {
    tableRow.isListed = listMode
    if listMode {
      button.isHidden = false
    } else {
      button.isHidden = true
    }
    layoutIfNeeded()
  }
  
  @objc func toggleCheck() {
    tableRow.isChecked = !tableRow.isChecked
    if tableRow.isChecked {
      button.setTitle(checked, for: .normal)
    } else {
      button.setTitle(unChecked, for: .normal)
    }
  }
}


extension TableViewCell: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    let size = textView.bounds.size
    let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
    
    if size.height != newSize.height {
      delegate?.didSizeChanged()
    }
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                replacementText text: String) -> Bool {
    
    let textString : NSString = textView.text as NSString
    let newTextString = textString.replacingCharacters(in: range, with: text)
    
    //처음 리스트 진입
    if newTextString.prefix(customTextView.bulletWithIndent.count) ==
      "\(customTextView.bulletWithIndent)" &&
      !newTextString.trimmingCharacters(in: .whitespaces).isEmpty &&
      !tableRow.isListed {
      textView.text = didStartListMode(currentText: newTextString)
      setListMode(listMode: true)
    }
    
    //리스트모드일때 백스페이스
    if textString == "" && newTextString == "" && tableRow.isListed {
      textView.text = didFinishListMode(currentText: newTextString)
      setListMode(listMode: false)
    }
    
    return true
  }
  
  private func didStartListMode(currentText: String) -> String {
    let startIndex = currentText.index(currentText.startIndex, offsetBy: customTextView.bulletWithIndent.count)
    let newLine = String(currentText[startIndex..<currentText.endIndex])
    return newLine
  }
  
  private func didFinishListMode(currentText: String) -> String {
    return customTextView.bullet + currentText
  }
}
