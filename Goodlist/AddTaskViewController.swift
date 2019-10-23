//
//  AddTaskViewController.swift
//  Goodlist
//
//  Created by Shabib Hossain on 2019-10-20.
//  Copyright © 2019 Code With Shabib. All rights reserved.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {

    @IBOutlet private weak var prioritySegment: UISegmentedControl!
    @IBOutlet private weak var taskTitleField: UITextField!
    
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }

    @IBAction private func saveAction() {
        guard
            let priority = Priority(rawValue: prioritySegment.selectedSegmentIndex),
            let title = taskTitleField.text else { return }
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        dismiss(animated: true, completion: nil)
    }
}
