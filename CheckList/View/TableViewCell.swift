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
  var shortcuts: [Shortcut] = []
  var currentShortcut = Shortcut()
  
  private lazy var customTextView: UITextView = {
    let textView = UITextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.isScrollEnabled = false
    textView.delegate = self
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    return textView
  }()
  
  private lazy var bulletButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(UIColor.black, for: UIControl.State.normal)
    button.setTitle(currentShortcut.unChecked, for: .normal)
    button.setTitle(currentShortcut.checked, for: UIControl.State.selected)
    button.addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
    button.sizeToFit()
    return button
  }()
  
  public func textViewBecomeFirstResponder() {
    self.customTextView.becomeFirstResponder()
  }
  
  func configure(indexPath: IndexPath, tableRow: TableRow, shortcuts: [Shortcut]) {
    selectionStyle = .none
    self.indexPath = indexPath
    self.tableRow = tableRow
    self.shortcuts = shortcuts
    addSubview(customTextView)
    setListMode(listState: tableRow.listState)
    
    switch tableRow.listState {
    case .list(let prevShortcut):
      self.currentShortcut = prevShortcut
    case .none:
      break
    }
    
    configCheckMode()
    customTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
    customTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
    customTextView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    customTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    customTextView.becomeFirstResponder()
  }
  
  func setListMode(listState: ListState) {
    
    tableRow.listState = listState
    switch listState {
    case .list(let prevShortcut):
      self.currentShortcut = prevShortcut
      customTextView.addSubview(bulletButton)
      bulletButton.setTitle(currentShortcut.unChecked, for: UIControl.State.normal)
      customTextView.textContainer.exclusionPaths = [UIBezierPath(rect: bulletButton.frame)]
    case .none:
      bulletButton.removeFromSuperview()
      customTextView.textContainer.exclusionPaths = []
    }
  }
  
  func configCheckMode() {
    if tableRow.isChecked {
      bulletButton.setTitle(currentShortcut.checked, for: .normal)
    } else {
      bulletButton.setTitle(currentShortcut.unChecked, for: .normal)
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
    var attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: textColor,
      .font: font,
      .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle]
    if isChecked {
      attributes.updateValue(NSUnderlineStyle.single.rawValue,
                             forKey: NSAttributedString.Key.strikethroughStyle)
    }
    customTextView.attributedText = NSAttributedString(string: customTextView.text,
                                                       attributes: attributes)
  }
  
  private func updateTableRowText() {
    tableRow.text = customTextView.text
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.tableRow = TableRow()
  }
}


extension TableViewCell: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    let size = textView.bounds.size
    let newSize = textView.sizeThatFits(CGSize(width: size.width,
                                               height: CGFloat.greatestFiniteMagnitude))
    
    if size.height != newSize.height {
      delegate?.didSizeChanged()
    }
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                replacementText text: String) -> Bool {
    
    let textString : NSString = textView.text as NSString
    let newTextString = textString.replacingCharacters(in: range, with: text)
    
    //처음 리스트 진입
    shortcuts.forEach { shortcut in
      if newTextString.prefix(1) == shortcut.bullet {
        self.currentShortcut = shortcut
      }
    }
    if newTextString.prefix(currentShortcut.bullet.count + 1) ==
      "\(currentShortcut.bullet) " &&
      !newTextString.trimmingCharacters(in: .whitespaces).isEmpty &&
      tableRow.listState == .none {
      textView.text = ""
      setListMode(listState: .list(currentShortcut))
      return false
    }
    
    //백스페이스
    if textString == "" && newTextString == "" {
      if tableRow.listState == .list(currentShortcut) {
        textView.text = getTextWithBullet(currentText: newTextString)
        setListMode(listState: .none)
        return false
      } else {
        didEscapeFromCell(isAdded: false)
        return false
      }
    }
    
    //enter
    if newTextString.last == "\n" {
      
      if tableRow.listState == .list(currentShortcut) && textString == "" {
        setListMode(listState: .none)
        return false
      } else {
        didEscapeFromCell(isAdded: true)
        return false
      }
    }
    
    return true
  }
  
  private func getTextWithBullet(currentText: String) -> String {
    return currentShortcut.bullet + currentText
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
