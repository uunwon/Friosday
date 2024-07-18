//
//  ViewController.swift
//  ToDoListApp
//
//  Created by uunwon on 7/12/24.
//

import UIKit

extension Date {
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
        
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Add Task", for: .normal)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.imagePadding = 10.0
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        
        button.configuration = config
        button.addAction(UIAction { [weak self] _ in
            let addTaskViewController = AddTaskViewController()
            addTaskViewController.completionHandler = { [weak self] in
                self?.updateLayout()
                self?.tableView.reloadData()
            }
            let navi = UINavigationController(rootViewController: addTaskViewController)
            self?.present(navi, animated: true)
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var emptyAddButtonCenterConstraints: [NSLayoutConstraint] = {
        return [
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
    }()
    
    private lazy var addButtonBottomConstraints: [NSLayoutConstraint] = {
        let safeArea = view.safeAreaLayoutGuide
        return [
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        ]
    }()
    
    private lazy var tableViewConstraints: [NSLayoutConstraint] = {
        let safeArea = view.safeAreaLayoutGuide
        return [
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20)
        ]
    }()
    
    var todayTodos: [Todo] {
        return TodoStore.shared.getList().filter { $0.date?.isToday ?? false }
    }
    
    var tomorrowTodos: [Todo] {
        return TodoStore.shared.getList().filter { $0.date?.isTomorrow ?? false }
    }
    
    var noDateTodos: [Todo] {
        return TodoStore.shared.getList().filter { $0.date == nil }
    }
    
    var otherTodos: [Todo] {
        return TodoStore.shared.getList().filter {
            !($0.date?.isToday ?? false) && !($0.date?.isTomorrow ?? false) && $0.date != nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TODO"
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(addButton)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        updateLayout()
    }
    
    // MARK: - Methods
    func updateLayout() {
        if TodoStore.shared.listCount > 0 {
            NSLayoutConstraint.deactivate(emptyAddButtonCenterConstraints)
            NSLayoutConstraint.activate(tableViewConstraints + addButtonBottomConstraints)
        } else {
            NSLayoutConstraint.deactivate(tableViewConstraints + addButtonBottomConstraints)
            NSLayoutConstraint.activate(emptyAddButtonCenterConstraints)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return todayTodos.count
        case 1:
            return tomorrowTodos.count
        case 2:
            return noDateTodos.count
        case 3:
            return otherTodos.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        
        guard let todo: Todo = switch indexPath.section {
        case 0: todayTodos[indexPath.row]
        case 1: tomorrowTodos[indexPath.row]
        case 2: noDateTodos[indexPath.row]
        case 3: otherTodos[indexPath.row]
        default: nil
        } else {
            fatalError("No Todo Data")
        }
        
        var config = cell.defaultContentConfiguration()
        config.text = todo.task
        
        if let dueDate = todo.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            config.secondaryText = formatter.string(from: dueDate)
            
            if dueDate < Date() {
                config.secondaryTextProperties.color = .red
            } else {
                config.secondaryTextProperties.color = .gray
            }
        }
        
        cell.contentConfiguration = config
        return cell
    }
}

