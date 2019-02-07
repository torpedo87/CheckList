//
//  ViewController.swift
//  CheckList
//
//  Created by junwoo on 07/02/2019.
//  Copyright © 2019 samchon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  private lazy var customTextView: CustomTextView = {
    let textView = CustomTextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.layer.borderWidth = 1
    textView.delegate = self
    return textView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(customTextView)
    
    customTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                        constant: 100).isActive = true
    customTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                            constant: 50).isActive = true
    customTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                             constant: -50).isActive = true
    customTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                           constant: -100).isActive = true
  }
}

extension ViewController: UITextViewDelegate {
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                replacementText text: String) -> Bool {
    
    let textString : NSString = textView.text as NSString
    let newTextString = textString.replacingCharacters(in: range, with: text)
    let lines = newTextString.components(separatedBy: .newlines)
    
    //list 사용중
    if customTextView.listMode {
      
      if text == "\n" {
        
        //enter 연속 두번
        if lines.joined(separator: "\n").suffix(customTextView.unCheckedWithIndent.count + 1) ==
          "\(customTextView.unCheckedWithIndent)\n" {
          textView.text = didSecondEnterAtListMode(lines: lines)
          setListMode(false)
          return true
        } else {
          textView.text = didEnterAtListMode(lines: lines)
          return false
        }
      }
    }
      
    //list 미사용중
    else {
      
      for (index, line) in lines.enumerated() {
        
        //list 입력시작
        if line.prefix(customTextView.bulletWithIndent.count) ==
          "\(customTextView.bulletWithIndent)" &&
          !line.trimmingCharacters(in: .whitespaces).isEmpty {
          textView.text = didBeginListMode(lines: lines, line: line, index: index)
          setListMode(true)
          return false
        }
      }
      
    }
    
    return true
  }
  
  private func didEnterAtListMode(lines: [String]) -> String {
    var newLines = lines
    newLines[lines.count - 1] = "\(customTextView.unCheckedWithIndent)"
    return newLines.joined(separator: "\n")
  }
  
  private func didSecondEnterAtListMode(lines: [String]) -> String {
    var newLines = lines
    newLines.removeLast()
    newLines.removeLast()
    return newLines.joined(separator: "\n")
  }
  
  private func didBeginListMode(lines: [String], line: String, index: Int) -> String {
    var newLines = lines
    let startIndex = line.index(line.startIndex, offsetBy: customTextView.bulletWithIndent.count)
    let newLine = "\(customTextView.unCheckedWithIndent)" + line[startIndex..<line.endIndex]
    newLines[index] = newLine
    return newLines.joined(separator: "\n")
  }
  
  private func setListMode(_ mode: Bool) {
    customTextView.listMode = mode
  }
}
