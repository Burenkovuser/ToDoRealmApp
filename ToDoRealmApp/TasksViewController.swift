//
//  TasksViewController.swift
//  ToDoRealmApp
//
//  Created by Vasilii on 05/09/2019.
//  Copyright © 2019 Vasilii Burenkov. All rights reserved.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {
    
    var currentTasksList: TasksList!
    
    var currentTasks: Results<Task>!
    var completedTasks: Results<Task>!
    
    @IBAction func editButtonPressed(_ sender: Any) {
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        alertForAddAndUpdateList()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       title = currentTasksList.name
        filteringTasks()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? currentTasks.count : completedTasks.count
    }
    // заголовок секции
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)

        var task: Task!
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note

        return cell
    }
    // заполняем массивы
    private func filteringTasks() {
        currentTasks = currentTasksList.tasks.filter("isCompleted = false")
        completedTasks = currentTasksList.tasks.filter("isCompleted = true")
        
        tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TasksViewController {
    
    private func alertForAddAndUpdateList() {
        
        let alert = UIAlertController(title: "New Task", message: "Please insert task value", preferredStyle: .alert)
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let text = taskTextField.text , !text.isEmpty else { return }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            taskTextField = textField
            taskTextField.placeholder = "New task"
        }
        
        alert.addTextField { textField in
            noteTextField = textField
            noteTextField.placeholder = "Note"
        }
        
        present(alert, animated: true)
    }
}

