//
//  ViewController.swift
//  ToDoApp-iOS13
//
//  Created by Ali Ünal on 13/12/2020.
//

import UIKit
import RealmSwift
class TodoListViewController: UITableViewController {

    var items: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category?{
        didSet{
            load()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        if let item = items?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = items?[indexPath.row]{
            do{
            try realm.write{
                item.done = !item.done
            }
            }catch{
                print("Error updating done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { [self] (action) in
            
            if let category = self.selectedCategory{
                let newItem = Item()
                newItem.title = textField.text!
  
            do{
            try realm.write{
      
                    category.items.append(newItem)
            }
            }catch{
                print("Error adding new item, \(error)")
            }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func save() {
        
    }
    
    func load() {
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        
    }


}

//MARK: - Search Bar Methods

//extension TodoListViewController: UISearchBarDelegate{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        if searchBar.text?.count == 0{
//            load()
//            
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//        
//    }
//}

