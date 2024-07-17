////
////  AddTaskViewController.swift
////  ToDoListApp
////
////  Created by uunwon on 7/17/24.
////
//
//import UIKit
//
//class AddTaskViewController: UIViewController {
//    private var submitButton: UIButton = {
//       let button = UIButton()
//        button.setTitle("저장", for: .normal)
//        button.layer.cornerRadius = 13
//        button.translatesAutoresizingMaskIntoConstraints = false
//        
//        var config = UIButton.Configuration.filled()
//        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
//            var outgoing = incoming
//            outgoing.font = UIFont.systemFont(ofSize: 18, weight: .light)
//            return outgoing
//        }
//        
//        config.baseBackgroundColor = .black
//        button.configuration = config
//        button.addAction(UIAction { [weak self] _ in
//            self.saveTodo()
//        }, for: .touchUpInside)
//        
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(dueDateStackView)
//    }
//
//    private func saveTodo() {
//        if let taskText = self.taskTextField.text, !taskText.isEmpty {
//            TodoStore.shared.addTodo(todo: Todo(id: UUID(), task: taskText, date: dueDate.getDate(), isDone: false))
//            print(TodoStore.shared.getList())
//            dismiss(animated: true)
//        } else {
//            let alert = UIAlertController(title: "할 일을 입력하세요", message: nil, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
//            present(alert, animated: true)
//        }
//    }
//
//}
