//
//  SettingViewController.swift
//  CheckList
//
//  Created by junwoo on 11/02/2019.
//  Copyright © 2019 samchon. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
  
  var shortcuts: [Shortcut] = [Shortcut(bullet: "-", unChecked: "O", checked: "V")]
  
  private lazy var bulletLabel: UILabel = {
    let label = UILabel()
    label.text = "단축키"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.sizeToFit()
    label.textAlignment = .center
    return label
  }()
  private lazy var unCheckedLabel: UILabel = {
    let label = UILabel()
    label.text = "체크전"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.sizeToFit()
    label.textAlignment = .center
    return label
  }()
  private lazy var checkedLabel: UILabel = {
    let label = UILabel()
    label.text = "체크후"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.sizeToFit()
    label.textAlignment = .center
    return label
  }()
  private lazy var headerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.yellow
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  private lazy var tableView: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(ShortcutCell.self, forCellReuseIdentifier: ShortcutCell.reuseIdentifier)
    table.dataSource = self
    return table
  }()
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private lazy var rightBarButtonItem: UIBarButtonItem = {
    let item = UIBarButtonItem(title: "save",
                               style: UIBarButtonItem.Style.plain,
                               target: self,
                               action: #selector())
    return item
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "emoji checklist"
    view.addSubview(headerView)
    view.addSubview(tableView)
    
    headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    headerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    
    
    headerView.addSubview(bulletLabel)
    headerView.addSubview(unCheckedLabel)
    headerView.addSubview(checkedLabel)
    
    headerView.addSubview(stackView)
    stackView.addArrangedSubview(bulletLabel)
    stackView.addArrangedSubview(unCheckedLabel)
    stackView.addArrangedSubview(checkedLabel)
    
    stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
    stackView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
  }
  
  @objc func saveShorcuts() {
    
  }
}

extension SettingViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shortcuts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: ShortcutCell.reuseIdentifier,
                                                for: indexPath) as? ShortcutCell {
      let shortcut = shortcuts[indexPath.row]
      cell.configure(shortcut: shortcut)
      return cell
    }
    return UITableViewCell()
  }
  
  
}
