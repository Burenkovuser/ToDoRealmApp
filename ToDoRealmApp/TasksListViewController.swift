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
        if sender.selectedSegmentIndex == 0 {
            tasksLists = tasksLists.sorted(byKeyPath: "name")
        } else {
            tasksLists = tasksLists.sorted(byKeyPath: "date")
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //заполняем созданную выше коллекцию элементами из базы данных
        tasksLists = realm.objects(TasksList.self)
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        /*
        if realm.isEmpty {
            NSObject.load()
        }
        */
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
    
    // чтобы при переходе обновлялась таблица, напр., когда возвращаемся с предыдущего экрана
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        cell.configure(with: tasksList)
        
        // вынесены в extention
       // cell.textLabel?.text = tasksList.name
       // cell.detailTextLabel?.text = "\(tasksList.tasks.count)"
        
        return cell
    }
    
    // MARK: - Table view delegate

    // в методе можно делать разные пользовательские действия
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let currentList = tasksLists[indexPath.row]
        
        let deliteAction = UITableViewRowAction(style: .default, title: "Delite") { _, _ in
            StorageManager.deleteTask(currentList) // удалеяем из базы
            tableView.deleteRows(at: [indexPath], with: .automatic) //удаляем из интерфейса
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (_, _) in
            self.alerForAddAndUpdateList(currentList, complition: {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        }
        
        let doneAction = UITableViewRowAction(style: .normal, title: "Done") { (_, _) in
            StorageManager.makeAllDone(currentList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        return [deliteAction, doneAction, editAction]
    }
    
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
    
    //делаем  nil чтобы можно было работать и с удалемем, когда параметра нет
    private func alerForAddAndUpdateList(_ listName: TasksList? = nil, complition: (() -> Void)? = nil) {
        
        var title = "New List"
        var doneButton = "Save"
        
        if listName != nil {
            title = "Edit List"
            doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newList = alertTextField.text , !newList.isEmpty else { return }
            
            if let listName = listName {
                StorageManager.editList(listName, newListName: newList)
                if complition != nil { complition!() }
            } else {
                let taskList = TasksList()
                taskList.name = newList
                
                StorageManager.saveTaskList(taskList)
                
                self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
                }
            }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "List Name"
        }
        
        if let listName = listName {
            alertTextField.text = listName.name
        }
        
        present(alert, animated: true)
    }
}
