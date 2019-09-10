//
//  TasksListViewController.swift
//  ToDoRealmApp
//
//  Created by Vasilii on 05/09/2019.
//  Copyright © 2019 Vasilii Burenkov. All rights reserved.
//

import UIKit
import RealmSwift

class TasksListViewController: UITableViewController {
    
    //создаем коллекцию и ниже ее инициализируем из базы
    var tasksLists: Results<TasksList>!
    
    @IBAction func editButtonPressed(_ sender: Any) {
    }
    
    @IBAction func  addButtonPressed(_ sender: Any) {
        alerForAddAndUpdateList()
    }
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //заполняем созданную выше коллекцию элементами из базы данных
        tasksLists = realm.objects(TasksList.self)
        
        if realm.isEmpty {
            NSObject.load()
        }
        
        // создаем списки разными способами
        
        /*
        let shoppingList = TasksList()
        shoppingList.name = "Shopping List"
        let moviesList = TasksList(value: ["Movie List", Date(), [["John Wick"], ["Tor", "", Date(), true]]])
        
        let milk = Task()
        milk.name = "Milk"
        milk.note = "2L"
        
        let bread = Task(value: ["Bread", "", Date(), true])
        let apples = Task(value: ["name": "Apples", "note": "2Kg"])
        
        shoppingList.tasks.append(milk)
        shoppingList.tasks.insert(contentsOf: [bread, apples], at: 1)
        
        // добавляем списки в базу и чтобы не занимать весь поток делаем асинхронно
        DispatchQueue.main.async {
            StorageManager.saveTaskLists([shoppingList, moviesList])
        }
 */
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
 */

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksLists.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        
        let tasksList = tasksLists[indexPath.row]
        cell.textLabel?.text = tasksList.name
        cell.detailTextLabel?.text = "\(tasksList.tasks.count)"
        
        return cell
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

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //если удается узнать индекс текущей ячейки
        if let indexPath = tableView.indexPathForSelectedRow {
            let tasksList = tasksLists[indexPath.row]
            let tasksVC = segue.destination as! TasksViewController
            tasksVC.currentTasksList = tasksList
        }
    }
}

private func load() {
    
    let shoppingList = TasksList()
    shoppingList.name = "Shopping List"
    
    let moviesList = TasksList(value: ["Movie List", Date(), [["John Wick"], ["Tor", "", Date(), true]]])
    
    let milk = Task()
    milk.name = "Milk"
    milk.note = "2L"
    
    let bread = Task(value: ["Bread", "", Date(), true])
    let apples = Task(value: ["name": "Apples", "note": "2Kg"])
    
    shoppingList.tasks.append(milk)
    shoppingList.tasks.insert(contentsOf: [bread, apples], at: 1)
    
    // добавляем списки в базу и чтобы не занимать весь поток делаем асинхронно
    DispatchQueue.main.async {
        StorageManager.saveTaskLists([shoppingList, moviesList])
    }
}

extension TasksListViewController {
    
    private func alerForAddAndUpdateList() {
        
        let alert = UIAlertController(title: "New List", message: "Please insert new value", preferredStyle: .alert)
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let text = alertTextField.text , !text.isEmpty else { return }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "List Name"
        }
        
        present(alert, animated: true)
    }
}
