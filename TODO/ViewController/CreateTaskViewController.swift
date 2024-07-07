//
//  CreateTask.swift
//  TODO
//
//  Created by Tomotaka Kawai on 2024/07/07.
//

import Foundation
import UIKit

protocol CreateTaskProtocol: AnyObject {
    func createNewTask(taskName: String) -> Void
}

class CreateTaskViewController: UIViewController {
    weak var delegate: CreateTaskProtocol?
    
    private let taskNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter task name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        initView()
    }
    
    // MARK: - initView
    func initView() {
        view.backgroundColor = .white
        
        self.title = "Create Task"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCloseButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTask))
        
        view.addSubview(taskNameTextField)
        
        NSLayoutConstraint.activate([
            taskNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: self.navigationController?.navigationBar.frame.height ?? 20),
            taskNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor),
            taskNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor),
            taskNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Actions
    @objc func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveTask() {
        guard let taskName = taskNameTextField.text, !taskName.isEmpty else {
            let alertController = UIAlertController(title: "Task name required", message: "Please enter a task name.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        delegate?.createNewTask(taskName: taskName)
        
        dismiss(animated: true)
    }
}
