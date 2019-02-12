//
//  SettingViewController.swift
//  CheckList
//
//  Created by junwoo on 11/02/2019.
//  Copyright © 2019 samchon. All rights reserved.
//

import UIKit

protocol ShortcutDelegate {
  func shortcutDidChange()
}

class SettingViewController: UIViewController {
  
  var shortcuts: [Shortcut] = []
  var delegate: ShortcutDelegate?
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
    table.register(ShortcutCell.self,
                   forCellReuseIdentifier: ShortcutCell.reuseIdentifier)
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
                               action: #selector(saveShorcuts))
    return item
  }()
  
  private lazy var addButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "add"), for: UIControl.State.normal)
    button.layer.cornerRadius = 25
    button.addTarget(self,
                     action: #selector(addButtonDidTap),
                     for: UIControl.Event.touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    self.shortcuts = fetchShorcuts()
    self.tableView.reloadData()
    
    title = "emoji checklist"
    navigationItem.rightBarButtonItem = rightBarButtonItem
    view.addSubview(headerView)
    view.addSubview(tableView)
    view.addSubview(addButton)
    
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
    
    addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
    addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
  }
  
  func fetchShorcuts() -> [Shortcut] {
    
    if let shortcutsData = UserDefaults.standard.object(forKey: "shortcuts") as? Data {
      if let loadedShortcuts = try? JSONDecoder().decode([Shortcut].self, from: shortcutsData) {
        return loadedShortcuts
      }
    }
    return []
  }
  
  @objc func saveShorcuts() {
    var shortcutArr = [Shortcut]()
    for index in 0..<shortcuts.count {
      let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! ShortcutCell
      if let shortcut = cell.getShortcut() {
        shortcutArr.append(shortcut)
      }
    }
    if let encoded = try? JSONEncoder().encode(shortcutArr) {
      UserDefaults.standard.set(encoded, forKey: "shortcuts")
      delegate?.shortcutDidChange()
    }
  }
  
  @objc func addButtonDidTap() {
    let emptyShortcut = Shortcut(bullet: "", unChecked: "", checked: "")
    self.shortcuts.append(emptyShortcut)
    let nextIndexPath = IndexPath(row: shortcuts.count - 1, section: 0)
    tableView.beginUpdates()
    tableView.insertRows(at: [nextIndexPath], with: .none)
    tableView.endUpdates()
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
