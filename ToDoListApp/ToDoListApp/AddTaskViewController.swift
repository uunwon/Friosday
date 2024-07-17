//
//  AddTaskViewController.swift
//  ToDoListApp
//
//  Created by uunwon on 7/17/24.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancleAddTask))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    // MARK: - Methods
    
    private func setUpUI() {
        view.backgroundColor = .white
        navigationItem.title = "Add Task"
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func cancleAddTask(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
