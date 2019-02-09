//
//  MainViewController.swift
//  CheckList
//
//  Created by junwoo on 07/02/2019.
//  Copyright © 2019 samchon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  private var dict: [IndexPath: TableRow] = [IndexPath(row: 0, section: 0) : TableRow()]
  
  private lazy var tableView: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
    table.dataSource = self
    table.rowHeight = UITableView.automaticDimension
    table.estimatedRowHeight = 44
    return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(tableView)
    
    tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
  }
  
}

extension MainViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dict.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier,
                                                for: indexPath) as? TableViewCell {
      let tableRow = dict[indexPath]!
      cell.configure(indexPath: indexPath, tableRow: tableRow)
      cell.delegate = self
      return cell
    }
    return UITableViewCell()
  }
  
}

extension MainViewController: TableViewCellDelegate {
  func addNextCell(indexPath: IndexPath, tableRow: TableRow) {
    dict[indexPath] = tableRow
    let newIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
    dict[newIndexPath] = TableRow(text: "", isListed: tableRow.isListed, isChecked: false)
    
    tableView.beginUpdates()
    tableView.insertRows(at: [newIndexPath], with: .automatic)
    tableView.endUpdates()
  }
  
  func deleteCell(indexPath: IndexPath) {
    dict.removeValue(forKey: indexPath)
    tableView.beginUpdates()
    tableView.deleteRows(at: [indexPath], with: .automatic)
    tableView.endUpdates()
  }
  
  func didSizeChanged() {
    UIView.setAnimationsEnabled(false)
    tableView.beginUpdates()
    tableView.endUpdates()
    UIView.setAnimationsEnabled(true)
  }
  
}
