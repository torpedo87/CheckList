//
//  MainViewController.swift
//  CheckList
//
//  Created by junwoo on 07/02/2019.
//  Copyright © 2019 samchon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  private var arr: [TableRow] = [TableRow()]
  private lazy var tableView: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
    table.dataSource = self
    table.rowHeight = UITableView.automaticDimension
    table.estimatedRowHeight = 44
    return table
  }()
  
  private lazy var leftBarButtonItem: UIBarButtonItem = {
    let item = UIBarButtonItem(title: "setting",
                               style: UIBarButtonItem.Style.plain,
                               target: self,
                               action: #selector(goToSetting))
    return item
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "memo"
    view.backgroundColor = .white
    navigationItem.leftBarButtonItem = leftBarButtonItem
    view.addSubview(tableView)
    
    tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
  }
  
  @objc func goToSetting() {
    let settingViewController = SettingViewController()
    navigationController?.pushViewController(settingViewController, animated: true)
  }
}

extension MainViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier,
                                                for: indexPath) as? TableViewCell {
      let tableRow = arr[indexPath.row]
      cell.configure(indexPath: indexPath, tableRow: tableRow)
      cell.delegate = self
      return cell
    }
    return UITableViewCell()
  }
  
}

extension MainViewController: TableViewCellDelegate {
  func addNextCell(indexPath: IndexPath, tableRow: TableRow) {
    
    arr[indexPath.row] = tableRow
    let newTableRow = TableRow(text: "", isListed: tableRow.isListed, isChecked: false)
    arr.append(newTableRow)
    let nextIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
    tableView.beginUpdates()
    tableView.insertRows(at: [nextIndexPath], with: .none)
    tableView.endUpdates()
    
    if let nextCell = tableView.cellForRow(at: nextIndexPath) as? TableViewCell {
      nextCell.textViewBecomeFirstResponder()
    }
  }
  
  func deleteCell(indexPath: IndexPath) {
    arr.remove(at: indexPath.row)
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
