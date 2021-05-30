//
//  HomeViewController.swift
//  ToDoApp
//
//  Created by Taro on 2021/05/29.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    var todoItems: Results<ToDoModel>?
    
    // UI
    @IBOutlet weak var todoListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
        // remove empty tableview cell
        self.todoListView.tableFooterView = UIView()
        
        // load todoitem list
        do {
            let realm = try Realm()
            self.todoItems = realm.objects(ToDoModel.self)
        } catch {
            NSLog("Init realm failed", error.localizedDescription)
        }
    }
    
    // NOTE: To use presentation.delegate, present by IBAction instead of segue
    @IBAction func addNavButtonClicked(_ sender: Any) {
        guard let rootAddViewController = storyboard?.instantiateViewController(identifier: "RootAddViewController") else {
            return
        }
        rootAddViewController.presentationController?.delegate = self

        present(rootAddViewController, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UITableViewDelegate {
    // go to EditViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let rootEditViewController: UINavigationController = storyboard?.instantiateViewController(identifier: "RootEditViewController"),
            let editViewController: EditViewController = rootEditViewController.topViewController as? EditViewController,
            let todoItem = self.todoItems?[indexPath.row]
        else {
            return
        }
        rootEditViewController.presentationController?.delegate = self
        
        editViewController.todoItem = todoItem
        
        present(rootEditViewController, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoItems?.count ?? 0
    }
    
    // create TableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let todoItems = self.todoItems else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        cell.textLabel?.text = todoItems[indexPath.row].title
        
        return cell
    }
    
    // delete TableViewCell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        do {
            let realm = try Realm()
            guard let todoItem = self.todoItems?[indexPath.row] else { throw NSError(domain: "todoItem is null", code: 404, userInfo: nil) }
            try realm.write {
                realm.delete(todoItem)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            NSLog("Init realm failed", error.localizedDescription)
        }
    }
}

extension HomeViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.todoListView.reloadData()
    }
}
