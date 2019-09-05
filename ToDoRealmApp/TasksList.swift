//
//  TasksList.swift
//  ToDoRealmApp
//
//  Created by Vasilii on 05/09/2019.
//  Copyright © 2019 Vasilii Burenkov. All rights reserved.
//

import RealmSwift

class TasksList: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>() //массив задач для realm
}
