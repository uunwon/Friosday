//
//  TodoStore.swift
//  ToDoListApp
//
//  Created by uunwon on 7/17/24.
//

import Foundation

struct Todo: Identifiable, Codable {
    let id: UUID
    let task: String
    let date: Date?
    let isDone: Bool
}


class TodoStore {
    static let shared = TodoStore()
    private var todoList: [Todo]
    
    private init() {
        todoList = []
    }
    
    func addTodo(todo: Todo) {
        todoList.append(todo)
    }
    
    func removeTodo(todo: Todo) {
        todoList = todoList.filter { $0.id != todo.id }
    }
    
    func getList() -> [Todo] {
        let list = todoList
        return list
    }
}