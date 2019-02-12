//
//  TableRow.swift
//  CheckList
//
//  Created by junwoo on 09/02/2019.
//  Copyright © 2019 samchon. All rights reserved.
//

import Foundation

enum ListState {
  case list(Shortcut)
  case none
}

extension ListState: Equatable {
  static func == (lhs: ListState, rhs: ListState) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none):
      return true
    case (.list, .list):
      return true
    default:
      return false
    }
  }
}

struct TableRow {
  var text: String = ""
  var listState: ListState = .none
  var isChecked: Bool = false
}
