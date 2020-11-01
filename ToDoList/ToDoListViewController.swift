//
//  ToDoListViewController.swift
//  ToDoList
//
/*
 MIT License
 
 Copyright (c) 2018 Gwinyai Nyatsoka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

protocol TodoListDelegate: class {
    func update(task: TodoItemModel,index: Int)
}

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var toDoItems: [TodoItemModel] = [TodoItemModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        title = "To Do List"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        let testItem = TodoItemModel(name: "Test item", details: "test details", completionDate: Date())
        
        self.toDoItems.append(testItem)
        
        let testItem2 = TodoItemModel(name: "Test item 2", details: "test details", completionDate: Date())
        self.toDoItems.append(testItem2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.setEditing(false, animated: false)
    }
    
    @objc func addTapped() {
        performSegue(withIdentifier: "AddTaskSegue", sender: nil)
    }
    @objc func editTapped() {
        tableView.setEditing(!tableView.isEditing, animated: true)
         
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTapped))
        }
        else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete =  UITableViewRowAction(style: .destructive, title: "Delete") { (action, IndexPath) in
            self.toDoItems.remove(at: IndexPath.row)
            self.tableView.deleteRows(at: [IndexPath], with: UITableView.RowAnimation.automatic)
        }
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = toDoItems[indexPath.row]
        let toDoTuple = (indexPath.row, selectedItem)
        performSegue(withIdentifier: "TaskDetailsSegue", sender: toDoTuple)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let todoItem = toDoItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem")!
        
        cell.textLabel?.text = todoItem.name
        cell.detailTextLabel?.text = todoItem.isComplete ? "Complete" : "Incomplete"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskDetailsSegue" {
            guard let destinationVC = segue.destination as? ToDoDetailsViewController else {return}
            
            guard let toDoItem = sender as? (Int,TodoItemModel) else {return}
            destinationVC.toDoItem = toDoItem.1
            destinationVC.toDoIndex = toDoItem.0
            destinationVC.delegate = self
        }
    }

}

extension ToDoListViewController: TodoListDelegate {
    func update(task: TodoItemModel, index: Int)  {
        toDoItems[index] = task
        
        tableView.reloadData()
    }
}
