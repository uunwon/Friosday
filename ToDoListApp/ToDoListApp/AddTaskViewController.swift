//
//  AddTaskViewController.swift
//  ToDoListApp
//
//  Created by uunwon on 7/17/24.
//

import UIKit

let TODAY_BUTTON_TAG = 1001
let TOMORROW_BUTTON_TAG = 1002
let NODUE_BUTTON_TAG = 1003
let DATEPICKER_TAG = 1004

enum DueDateType {
    case today
    case tomorrow
    case none
    case someday(date: Date)
    
    func getDate() -> Date? {
        switch self {
        case .today:
            return Date()
        case .tomorrow:
            return Calendar.current.date(bySetting: .day, value: 1, of: Date())
        case .none:
            return nil
        case .someday(let date):
            return date
        }
    }
    
    func isSelected(tag: Int) -> Bool {
        switch self {
        case .today:
            return tag == TODAY_BUTTON_TAG
        case .tomorrow:
            return tag == TOMORROW_BUTTON_TAG
        case .none:
            return tag == NODUE_BUTTON_TAG
        case .someday(let date):
            return tag == DATEPICKER_TAG
        }
    }
}

class AddTaskViewController: UIViewController {
    var dueDate: DueDateType = .none {
        didSet {
            updateDueButtons()
        }
    }
    
    private var taskTextField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 18, weight: .light)
        textField.placeholder = "할 일을 적어주세요 . ."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var dueDatePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.tag = DATEPICKER_TAG
        datePicker.addAction(UIAction { [weak self] action in
            if let picker = action.sender as? UIDatePicker {
                print("date: \(picker.date.ISO8601Format())")
                self?.dueDate = .someday(date: picker.date)
                picker.resignFirstResponder()
            }
        }, for: .valueChanged)
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
        todayButton.tag = TODAY_BUTTON_TAG
        todayButton.layer.cornerRadius = 6
        todayButton.configuration = config
        todayButton.addAction(UIAction { [weak self] _ in
            self?.dueDate = .today
        }, for: .touchUpInside)
        
        let tomorrowButton = UIButton(type: .custom)
        tomorrowButton.setTitle("내일", for: .normal)
        tomorrowButton.tag = TOMORROW_BUTTON_TAG
        tomorrowButton.layer.cornerRadius = 6
        tomorrowButton.configuration = config
        tomorrowButton.addAction(UIAction { [weak self] _ in
            self?.dueDate = .tomorrow
        }, for: .touchUpInside)
        
        let noDueButton = UIButton(type: .custom)
        noDueButton.setTitle("미지정", for: .normal)
        noDueButton.tag = NODUE_BUTTON_TAG
        noDueButton.layer.cornerRadius = 6
        noDueButton.configuration = config
        noDueButton.addAction(UIAction { [weak self] _ in
            self?.dueDate = .none
        }, for: .touchUpInside)
        
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
        
        submitButton.addAction(UIAction { [weak self] _ in
            self?.saveTodo()
        }, for: .touchUpInside)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        updateLayout()
        updateDueButtons()
    }
    
    // MARK: - Methods
    private func setUpUI() {
        view.backgroundColor = .white
        navigationItem.title = "Add Task"
        navigationItem.leftBarButtonItem = leftButton
    }
    
    private func updateLayout() {
        NSLayoutConstraint.activate(taskTextFieldConstraints + dueDateStackViewConstraints + submitButtonConstraints)
    }
    
    private func updateDueButtons() {
        dueDateStackView.subviews.forEach { element in
            if let button = element as? UIButton {
                button.isSelected = dueDate.isSelected(tag: element.tag)
            } else {
                print("Date Picker")
            }
        }
    }
    
    private func saveTodo() {
        if let taskText = self.taskTextField.text, !taskText.isEmpty {
            TodoStore.shared.addTodo(todo: Todo(id: UUID(), task: taskText, date: dueDate.getDate(), isDone: false))
            print(TodoStore.shared.getList())
            dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "할 일을 입력하세요", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    @objc func cancleAddTask(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
