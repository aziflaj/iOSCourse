//
//  TodoList.swift
//  CheckList
//
//  Created by Aldo Ziflaj on 16/06/2019.
//  Copyright © 2019 Aldo Ziflaj. All rights reserved.
//

import Foundation

class TodoList {
  var todos: [ChecklistItem] = []
  
  init() {
    todos = [
      ChecklistItem(withText: "Take a jog"),
      ChecklistItem(withText: "Watch a movie"),
      ChecklistItem(withText: "Code an app"),
      ChecklistItem(withText: "Walk the dog"),
      ChecklistItem(withText: "Study Design Patterns")
    ]
  }
}
