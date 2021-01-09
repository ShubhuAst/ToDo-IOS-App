//
//  ViewController.swift
//  ToDo
//
//  Created by SHUBHAM ASTHANA on 09/01/21.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArr = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }

    //Data Source Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArr[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //Table View Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArr[indexPath.row].done = !itemArr[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //popup alert to add item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //add item when clicked add
            let newItem = Item()
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArr.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //manipulate persistent data model(using NSCoder)
    func saveItems() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArr)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Error encoding itme  array \(error)")
        }
        self.tableView.reloadData()
    }
    
    //load items from persistemst data model(using NSCoder)
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArr = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding item array \(error)")
            }
        }
    }
    
}
