//
//  ViewController.swift
//  ToDoListApp
//
//  Created by uunwon on 7/12/24.
//

import UIKit

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
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.imagePadding = 10.0
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableViewConstraints: [NSLayoutConstraint] = {
        let safeArea = view.safeAreaLayoutGuide
        return [
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ]
    }()
    
    private lazy var addButtonConstraints: [NSLayoutConstraint] = {
        return [
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TODO"
        
        view.backgroundColor = .lemon
        view.addSubview(tableView)
        view.addSubview(addButton)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        updateLayout()
    }
    
    // MARK: - Methods
    func updateLayout() {
        NSLayoutConstraint.activate(tableViewConstraints + addButtonConstraints)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        return cell
    }
}

