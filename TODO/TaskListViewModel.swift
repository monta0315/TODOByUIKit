//
//  TaskListViewModel.swift
//  TODO
//
//  Created by Kawai, Tomotaka | Monta | TMO on 2024/06/22.
//

import Foundation

class TaskListViewModel {
    private var tasks: [Task] = []
    var taskIds: [UUID] {
       return tasks.map(\.id)
    }

    init() {
        initTaskRegister()
    }

    func numberOfTasks() -> Int {
        return tasks.count
    }

    func getTasks() -> [Task] {
        return tasks
    }

    func getTaskById(id: UUID) -> Task? {
        return tasks.first(where: {$0.id == id})
    }

    func removeTaskById(id: UUID) {
        tasks = tasks.filter{$0.id != id}
    }

    func initTaskRegister() {
        let taskNames = ["task1", "task2", "task3"]

        taskNames.forEach { name in
            let task = Task(taskName: name, id: UUID())
            tasks.append(task)
        }
    }
}