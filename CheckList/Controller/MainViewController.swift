//
//  MainViewController.swift
//  CheckList
//
//  Created by junwoo on 07/02/2019.
//  Copyright © 2019 samchon. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
  private var shortcuts: [Shortcut] = []
  private var tableRows: [TableRow] = [TableRow()]
  
  private lazy var leftBarButtonItem: UIBarButtonItem = {
    let item = UIBarButtonItem(title: "setting",
                               style: UIBarButtonItem.Style.plain,
                               target: self,
                               action: #selector(pushSettingViewController))
    return item
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    tableView.register(TableViewCell.self,
                   forCellReuseIdentifier: TableViewCell.reuseIdentifier)
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    tableView.separatorStyle = .none
    self.shortcuts = fetchShorcuts()
    title = "memo"
    view.backgroundColor = .white
    navigationItem.leftBarButtonItem = leftBarButtonItem
  }
  
  @objc func pushSettingViewController() {
    let settingViewController = SettingViewController()
    settingViewController.delegate = self
    navigationController?.pushViewController(settingViewController,
                                             animated: true)
  }
  
  func fetchShorcuts() -> [Shortcut] {
    
    if let shortcutsData = UserDefaults.standard.object(forKey: "shortcuts") as? Data {
      if let loadedShortcuts = try? JSONDecoder().decode([Shortcut].self,
                                                         from: shortcutsData) {
        return loadedShortcuts
      }
    }
    return []
  }
}

extension MainViewController {
  
  override func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return tableRows.count
  }
  
  override func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier,
                                                for: indexPath) as? TableViewCell {
      let tableRow = tableRows[indexPath.row]
      cell.configure(indexPath: indexPath, tableRow: tableRow, shortcuts: shortcuts)
      cell.delegate = self
      return cell
    }
    return UITableViewCell()
  }
  
}

extension MainViewController: TableViewCellDelegate {
  
  func addNextCell(indexPath: IndexPath, tableRow: TableRow, text: String) {
    tableRows[indexPath.row] = tableRow
    let newTableRow = TableRow(text: text,
                               listState: tableRow.listState,
                               isChecked: false,
                               cursorOffset: -text.count)
    tableRows.append(newTableRow)
    let nextIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
    tableView.beginUpdates()
    tableView.insertRows(at: [nextIndexPath], with: .none)
    tableView.endUpdates()
    if let nextCell = tableView.cellForRow(at: nextIndexPath) as? TableViewCell {
      nextCell.textViewBecomeFirstResponder()
    }
  }
  
  func deleteCell(indexPath: IndexPath, text: String) {
    tableRows[indexPath.row - 1].text += text
    tableRows[indexPath.row - 1].cursorOffset = -text.count
    tableView.reloadRows(at: [IndexPath(row: indexPath.row - 1,
                                        section: indexPath.section)],
                         with: .none)
    tableRows.remove(at: indexPath.row)
    tableView.beginUpdates()
    tableView.deleteRows(at: [indexPath], with: .none)
    tableView.endUpdates()
    let prevIndexPath = IndexPath(row: indexPath.row - 1, section: 0)
    if let prevCell = tableView.cellForRow(at: prevIndexPath) as? TableViewCell {
      prevCell.textViewBecomeFirstResponder()
    }
  }
  
  func didSizeChanged() {
    UIView.setAnimationsEnabled(false)
    tableView.beginUpdates()
    tableView.endUpdates()
    UIView.setAnimationsEnabled(true)
  }
  
}

extension MainViewController: ShortcutDelegate {
  func shortcutDidChange() {
    self.shortcuts = fetchShorcuts()
    self.tableView.reloadData()
  }
}
