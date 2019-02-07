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
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let textString : NSString = textView.text as NSString
    
    let newTextString = textString.replacingCharacters(in: range, with: text)
    
    let lines = newTextString.components(separatedBy: .newlines)
    for (index, line) in lines.enumerated() {
      
      //current line
      if index == lines.count - 1 {
        print(line)
      }
    }
    
    return true
  }
}
