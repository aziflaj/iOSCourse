//
//  AddItemTableViewController.swift
//  CheckList
//
//  Created by Aldo Ziflaj on 16/06/2019.
//  Copyright © 2019 Aldo Ziflaj. All rights reserved.
//

import UIKit

protocol ItemDetailControllerDelegate: class {
  func addItemViewControllerDidCancel(_ controller: ItemDetailViewController)
  func addItemViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
  func addItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {
  
  weak var delegate: ItemDetailControllerDelegate?
  
  weak var todolist: TodoList?
  weak var itemToEdit: ChecklistItem?
  
  @IBOutlet weak var addButton: UIBarButtonItem!
  @IBOutlet weak var textfield: UITextField!
  
  override func viewWillAppear(_ animated: Bool) {
    textfield.becomeFirstResponder()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never
    
    if itemToEdit != nil {
      title = "Edit Item"
      textfield.text = itemToEdit?.text
      addButton.isEnabled = true
    }
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
  @IBAction func handleCancel(_ sender: Any) {
    delegate?.addItemViewControllerDidCancel(self)
  }
  
  @IBAction func handleAddingTodoItem(_ sender: Any) {
    if let item = itemToEdit, let text = textfield.text {
      item.text = text
      delegate?.addItemViewController(self, didFinishEditing: item)
    } else if let item = todolist?.newTodo(), let text = textfield.text {
      item.text = text
      delegate?.addItemViewController(self, didFinishAdding: item)
    }
  }
}

extension ItemDetailViewController : UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textfield.resignFirstResponder()
    return false
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let oldText = textfield.text,
      let stringRange = Range(range, in: oldText) else {
        return false
    }
    
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    if newText.isEmpty {
      addButton.isEnabled = false
    } else {
      addButton.isEnabled = true
    }
    
    return true
  }
}
