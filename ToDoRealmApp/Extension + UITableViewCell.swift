//
//  Extension + UITableViewCell.swift
//  ToDoRealmApp
//
//  Created by Vasilii on 11/09/2019.
//  Copyright © 2019 Vasilii Burenkov. All rights reserved.
//

import UIKit

// раширяем возможности стандартной ячейки
extension UITableViewCell {
    func configure(with taskList: TasksList) {
        let currentTasks = taskList.tasks.filter("isCompleted = false")
        let completedTasks = taskList.tasks.filter("isCompleted = true")
        
        textLabel?.text = taskList.name
        
        if !currentTasks.isEmpty {
            detailTextLabel?.text = "\(currentTasks.count)"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        } else if !completedTasks.isEmpty {
            detailTextLabel?.text = "✓"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            detailTextLabel?.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        } else {
            detailTextLabel?.text = "0"
        }
    }
}
