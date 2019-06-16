//
//  AddItemTableViewController.swift
//  CheckList
//
//  Created by Aldo Ziflaj on 16/06/2019.
//  Copyright © 2019 Aldo Ziflaj. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {
  
  @IBOutlet weak var addButton: UIBarButtonItem!
  @IBOutlet weak var textfield: UITextField!
  
  override func viewWillAppear(_ animated: Bool) {
    textfield.becomeFirstResponder()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
  @IBAction func handleCancel(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func handleAddingTodoItem(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

extension AddItemTableViewController : UITextFieldDelegate {
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
