//
//  ViewController.swift
//  CheckList
//
//  Created by Aldo Ziflaj on 15/06/2019.
//  Copyright © 2019 Aldo Ziflaj. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
  let todoList = TodoList()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoList.todos.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    let item = todoList.todos[indexPath.row]
    
    configureText(for: cell, with: item)
    configureCheckmark(for: cell, with: item)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      let item = todoList.todos[indexPath.row]
      
      configureCheckmark(for: cell, with: item)
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    todoList.todos.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
  @IBAction func addTodoItemHandler(_ sender: Any?) {
    let newIndexRow = todoList.todos.count
    _ = todoList.newTodo()
    
    let indexPath = IndexPath(row: newIndexRow, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
  }
  
  func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
    if let label = cell.viewWithTag(1000) as? UILabel {
      label.text = item.text
    }
  }
  
  func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    if item.checked {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    
    item.toggleChecked()
  }
}

