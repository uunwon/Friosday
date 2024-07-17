//
//  AddTaskViewController.swift
//  ToDoListApp
//
//  Created by uunwon on 7/17/24.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    private var taskTextField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 18, weight: .light)
        textField.placeholder = "할 일을 적어주세요 . ."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var dueDatePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private lazy var dueDateStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.bordered()
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        
        let todayButton = UIButton(type: .custom)
        todayButton.setTitle("오늘", for: .normal)
        todayButton.layer.cornerRadius = 6
        todayButton.configuration = config
        
        let tomorrowButton = UIButton(type: .custom)
        tomorrowButton.setTitle("내일", for: .normal)
        todayButton.layer.cornerRadius = 6
        tomorrowButton.configuration = config
        
        let noDueButton = UIButton(type: .custom)
        noDueButton.setTitle("미지정", for: .normal)
        todayButton.layer.cornerRadius = 6
        noDueButton.configuration = config
        
        stackView.addArrangedSubview(todayButton)
        stackView.addArrangedSubview(tomorrowButton)
        stackView.addArrangedSubview(noDueButton)
        stackView.addArrangedSubview(dueDatePicker)
        
        return stackView
    }()
    
    private var submitButton: UIButton = {
       let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.layer.cornerRadius = 13
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 18, weight: .light)
            return outgoing
        }
        
        config.baseBackgroundColor = .black
        button.configuration = config
        return button
    }()
    
    // MARK: - UILayout Constraints
    private lazy var taskTextFieldConstraints: [NSLayoutConstraint] = {
        let safeArea = view.safeAreaLayoutGuide
        return [
            taskTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            taskTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            taskTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20)
        ]
    }()
    
    private lazy var dueDateStackViewConstraints: [NSLayoutConstraint] = {
        let safeArea = view.safeAreaLayoutGuide
        return [
            dueDateStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            dueDateStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            dueDateStackView.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20)
        ]
    }()
    
    private lazy var submitButtonConstraints: [NSLayoutConstraint] = {
        let safeArea = view.safeAreaLayoutGuide
        return [
            submitButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            submitButton.topAnchor.constraint(equalTo: dueDateStackView.bottomAnchor, constant: 20)
        ]
    }()
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancleAddTask))
        button.tintColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        view.addSubview(taskTextField)
        view.addSubview(dueDateStackView)
        view.addSubview(submitButton)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        updateLayout()
    }
    
    // MARK: - Methods
    private func setUpUI() {
        view.backgroundColor = .white
        navigationItem.title = "Add Task"
        navigationItem.leftBarButtonItem = leftButton
    }
    
    func updateLayout() {
        NSLayoutConstraint.activate(taskTextFieldConstraints + dueDateStackViewConstraints + submitButtonConstraints)
    }
    
    @objc func cancleAddTask(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
