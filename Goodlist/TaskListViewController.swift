//
//  TaskListViewController.swift
//  Goodlist
//
//  Created by Shabib Hossain on 2019-10-20.
//  Copyright © 2019 Code With Shabib. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TaskListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var prioritySegment: UISegmentedControl!
    
    private let disposeBag = DisposeBag()
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()

    @IBAction private func priorityChangedAction() {
        let priority = Priority(rawValue: prioritySegment.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let navC = segue.destination as? UINavigationController,
            let addTaskVC = navC.viewControllers.first as? AddTaskViewController else {
                fatalError("crash")
        }
        addTaskVC.taskSubjectObservable.subscribe(onNext: { [weak self] task in
            guard let `self` = self else { return }
            
            var existingTask = self.tasks.value
            existingTask.append(task)
            self.tasks.accept(existingTask)
            
            let priority = Priority(rawValue: self.prioritySegment.selectedSegmentIndex - 1)
            self.filterTasks(by: priority)
        }).disposed(by: disposeBag)
    }
    
    private func filterTasks(by priority: Priority?) {
        guard let priority = priority else {
            filteredTasks = tasks.value
            updateTableView()
            return
        }
        tasks.map { tasks in
            return tasks.filter { $0.priority == priority }
        }.subscribe(onNext: { [weak self] tasks in
            self?.filteredTasks = tasks
            self?.updateTableView()
        }).disposed(by: disposeBag)
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension TaskListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableCell", for: indexPath)
        let task = filteredTasks[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
}

