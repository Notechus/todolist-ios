//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Sebastian Paulus on 17/12/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70.0
        
        self.loadCategories()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let currentCategory = categories?[indexPath.row] {
            cell.textLabel?.text = currentCategory.name
            cell.backgroundColor = UIColor(hexString: currentCategory.color)
        } else {
            cell.textLabel?.text = "No categories added"
            cell.backgroundColor = UIColor.white
        }
        
        
        
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            if let category = textField.text {
                if category != "" {
                    let newCategory = Category()
                    newCategory.name = category
                    newCategory.color = UIColor.randomFlat().hexValue()
                    
                    self.save(category: newCategory)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type category name"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Could not delete category, \(error)")
            }
            self.tableView.reloadData()
        }
    }
}

// MARK: - Core Data

extension CategoryViewController {
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        self.categories = realm.objects(Category.self)
        self.tableView.reloadData()
    }
}

// MARK: - Table View Delegate

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Navigation.categoryToItemsSegue, sender: self)
    }
}
