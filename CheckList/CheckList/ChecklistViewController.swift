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
    navigationItem.leftBarButtonItem = editButtonItem
    tableView.allowsMultipleSelectionDuringEditing = true
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    tableView.setEditing(tableView.isEditing, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let section = priorityForSectionIndex(section) {
      return todoList.todoList(for: section).count
    }
    
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    
    if let priority = priorityForSectionIndex(indexPath.section) {
      let items = todoList.todoList(for: priority)
      let item = items[indexPath.row]
      configureText(for: cell, with: item)
      configureCheckmark(for: cell, with: item)
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView.isEditing {
      return
    }
    
    if let cell = tableView.cellForRow(at: indexPath), let priority = priorityForSectionIndex(indexPath.section) {
      let items = todoList.todoList(for: priority)
      let item = items[indexPath.row]
      
      item.toggleChecked()
      configureCheckmark(for: cell, with: item)
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if let priority = priorityForSectionIndex(indexPath.section) {
      let items = todoList.todoList(for: priority)
      let item = items[indexPath.row]
      todoList.remove(item, from: priority, at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    if let oldPriority = priorityForSectionIndex(sourceIndexPath.section),
      let newPriority = priorityForSectionIndex(destinationIndexPath.section) {
      let items = todoList.todoList(for: oldPriority)
      let item = items[sourceIndexPath.row]
      
      todoList.move(item: item, from: oldPriority, at: sourceIndexPath.row, to: newPriority, at: destinationIndexPath.row)
    }
    
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch priorityForSectionIndex(section)! {
    case .high:
      return "High Priority TODOs"
    case .medium:
      return "Medium Priority TODOs"
    case .low:
      return "Low Priority TODOs"
    case .no:
      return "No Priority TODOs"
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return TodoList.Priority.allCases.count
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItemSegue" {
      if let addItemViewController = segue.destination as? ItemDetailViewController {
        addItemViewController.delegate = self
        addItemViewController.todolist = todoList
      }
    } else if segue.identifier == "EditItemSegue" {
      if let addItemViewController = segue.destination as? ItemDetailViewController {
        if let cell = sender as? UITableViewCell,
          let indexPath = tableView.indexPath(for: cell),
          let priority = priorityForSectionIndex(indexPath.section) {
          addItemViewController.delegate = self
          let checklistItem = todoList.todoList(for: priority)[indexPath.row]
          addItemViewController.itemToEdit = checklistItem
        }
      }
    }
  }
  
  @IBAction func addTodoItemHandler(_ sender: Any?) {
    let newIndexRow = todoList.todoList(for: .medium).count
    _ = todoList.newTodo()
    
    let indexPath = IndexPath(row: newIndexRow, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
  }
  
  @IBAction func deleteItems(_ sender: Any) {
    if let selectedRows = tableView.indexPathsForSelectedRows {
      for indexPath in selectedRows {
        if let priority = priorityForSectionIndex(indexPath.section) {
          let todos = todoList.todoList(for: priority)
          let item = todos[indexPath.row]
          todoList.remove(item, from: priority, at: indexPath.row)
        }
      }
      
      tableView.beginUpdates()
      tableView.deleteRows(at: selectedRows, with: .automatic)
      tableView.endUpdates()
    }
  }
  
  func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
    if let checkmarkCell = cell as? ChecklistTableViewCell {
      checkmarkCell.todoTextLabel.text = item.text
    }
  }
  
  func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    guard let checkmarkCell = cell as? ChecklistTableViewCell else {
      return
    }
    
    if item.checked {
      checkmarkCell.checkmarkLabel.text = "√"
    } else {
      checkmarkCell.checkmarkLabel.text = ""
    }
  }
  
  private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? {
    return TodoList.Priority(rawValue: index)
  }
}

extension ChecklistViewController : ItemDetailControllerDelegate {
  func addItemViewControllerDidCancel(_ controller: ItemDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func addItemViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
    navigationController?.popViewController(animated: true)
    let rowIndex = todoList.todoList(for: .medium).count - 1
    
    let indexPath = IndexPath(row: rowIndex, section: TodoList.Priority.medium.rawValue)
    tableView.insertRows(at: [indexPath], with: .automatic)
  }
  
  func addItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
    for priority in TodoList.Priority.allCases {
      let currentList = todoList.todoList(for: priority)
      if let index = currentList.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: priority.rawValue)
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
      }
    }
    navigationController?.popViewController(animated: true)
  }
}
