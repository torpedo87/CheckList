//
//  TableViewCell.swift
//  CheckList
//
//  Created by junwoo on 07/02/2019.
//  Copyright © 2019 samchon. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate: class {
  func didSizeChanged()
  func addNextCell(indexPath: IndexPath, tableRow: TableRow)
  func deleteCell(indexPath: IndexPath)
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
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    return textView
  }()
  
  private lazy var bulletButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor.green
    button.setTitle(unChecked, for: .normal)
    button.setTitle(checked, for: UIControl.State.selected)
    button.addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
    button.sizeToFit()
    return button
  }()
  
  func configure(indexPath: IndexPath, tableRow: TableRow) {
    selectionStyle = .none
    self.indexPath = indexPath
    self.tableRow = tableRow
    
    addSubview(customTextView)
    setListMode(listMode: tableRow.isListed)
    configCheckMode()
    
    customTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
    customTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
    customTextView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    customTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    customTextView.becomeFirstResponder()
  }
  
  func setListMode(listMode: Bool) {
    tableRow.isListed = listMode
    if listMode {
      customTextView.addSubview(bulletButton)
      bulletButton.setTitle(bullet, for: UIControl.State.normal)
      customTextView.textContainer.exclusionPaths = [UIBezierPath(rect: bulletButton.frame)]
    } else {
      bulletButton.removeFromSuperview()
    }
    layoutIfNeeded()
  }
  
  func configCheckMode() {
    if tableRow.isChecked {
      bulletButton.setTitle(checked, for: .normal)
    } else {
      bulletButton.setTitle(unChecked, for: .normal)
    }
    setAttrbutedString(isChecked: tableRow.isChecked)
  }
  
  @objc func toggleCheck() {
    
    tableRow.isChecked = !tableRow.isChecked
    configCheckMode()
  }
  
  private func setAttrbutedString(isChecked: Bool) {
    let font = UIFont.preferredFont(forTextStyle: .body)
    let textColor = isChecked ? UIColor.lightGray : UIColor.black
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: textColor,
      .font: font,
      .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle]
    customTextView.attributedText = NSAttributedString(string: customTextView.text, attributes: attributes)
  }
  
  private func updateTableRowText() {
    tableRow.text = customTextView.text
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
      textView.text = getTextWithoutBullet(currentText: newTextString)
      setListMode(listMode: true)
    }
    
    //백스페이스
    if textString == "" && newTextString == "" {
      if tableRow.isListed {
        textView.text = getTextWithBullet(currentText: newTextString)
        setListMode(listMode: false)
      } else {
        didEscapeFromCell(isAdded: false)
      }
    }
    
    //enter
    if newTextString.last == "\n" {
      
      if tableRow.isListed && textString == "" {
        setListMode(listMode: false)
      } else {
        didEscapeFromCell(isAdded: true)
      }
    }
    
    return true
  }
  
  private func getTextWithoutBullet(currentText: String) -> String {
    let startIndex = currentText.index(currentText.startIndex, offsetBy: customTextView.bulletWithIndent.count)
    let newLine = String(currentText[startIndex..<currentText.endIndex])
    return newLine
  }
  
  private func getTextWithBullet(currentText: String) -> String {
    return customTextView.bullet + currentText
  }
  
  private func didEscapeFromCell(isAdded: Bool) {
    updateTableRowText()
    if isAdded {
      delegate?.addNextCell(indexPath: indexPath, tableRow: tableRow)
    } else if indexPath.row != 0 {
      delegate?.deleteCell(indexPath: indexPath)
    }
  }
}
