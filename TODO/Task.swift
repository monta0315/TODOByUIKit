//
//  Task.swift
//  TODO
//
//  Created by Kawai, Tomotaka | Monta | TMO on 2024/06/22.
//

import Foundation

struct Task: Identifiable {
    var id: UUID
    private var isDone: Bool = false
    private let taskName: String

    init(taskName: String, id: UUID) {
        self.taskName = taskName
        self.id = id
    }

    func getTaskName() -> String {
        return taskName
    }

    func getIsDone() -> Bool {
        return isDone
    }
}
