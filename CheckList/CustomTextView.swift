//
//  CustomTextView.swift
//  CheckList
//
//  Created by junwoo on 07/02/2019.
//  Copyright © 2019 samchon. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {
  var bullet: String = "-"
  var checked: String = "v"
  var unChecked: String = "ㅁ"
  var listMode: Bool = false
  
  lazy var unCheckedWithIndent: String = {
    return unChecked + " "
  }()
  lazy var checkedWithIndent: String = {
    return checked + " "
  }()
  lazy var bulletWithIndent: String = {
    return bullet + " "
  }()
}
