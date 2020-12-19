//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<TodoItem>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 55.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = self.todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let todo = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    todo.done = !todo.done
                }
            } catch {
                print("Error updating item \(error)")
            }
            self.tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            if let todo = textField.text {
                if todo != "", let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let todoItem = TodoItem()
                            todoItem.title = textField.text!
                            currentCategory.items.append(todoItem)
                        }
                    } catch {
                        print("Error adding item \(error)")
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let todoItem = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(todoItem)
                }
            } catch {
                print("Could not delete category, \(error)")
            }
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - Core Data

extension TodoListViewController {
    func loadItems() {
        self.todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
    }
}

// MARK: - Searching

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.todoItems = self.todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
