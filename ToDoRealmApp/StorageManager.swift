//
//  StorageManager.swift
//  ToDoRealmApp
//
//  Created by Vasilii on 05/09/2019.
//  Copyright © 2019 Vasilii Burenkov. All rights reserved.
//

import RealmSwift

// Get the default Realm
let realm = try! Realm() // точка входа в базу данных

class StorageManager {
    
    static func saveTaskLists(_ tasksLists: [TasksList]) {
        // Persist your data easily
        try! realm.write {
            realm.add(tasksLists)
        }
    }
}
