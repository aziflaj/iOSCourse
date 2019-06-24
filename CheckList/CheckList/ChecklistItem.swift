//
//  ChecklistItem.swift
//  CheckList
//
//  Created by Aldo Ziflaj on 16/06/2019.
//  Copyright © 2019 Aldo Ziflaj. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
  @objc var text: String
  var checked: Bool
  
  override init() {
    text = ""
    checked = false
  }
  
  init(withText text: String, checked: Bool = false) {
    self.text = text
    self.checked = checked
  }
  
  func toggleChecked() {
    checked = !checked
  }
}
