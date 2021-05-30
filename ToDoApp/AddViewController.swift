//
//  AddViewController.swift
//  ToDoApp
//
//  Created by Taro on 2021/05/29.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
    
    // UI
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add"
        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(textFieldDidChange),
                    name: UITextField.textDidChangeNotification,
                    object: self.titleTextField)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // validation
    @objc func textFieldDidChange() {
        let isEmpty = self.titleTextField.text?.isEmpty ?? true
        self.addButton.isSelected = !isEmpty
        self.addButton.alpha = isEmpty ? 0.5 : 1.0
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        do {
            let realm = try Realm()
            
            let todo = ToDoModel()
            todo.title = self.titleTextField.text ?? ""
            
            try realm.write {
                realm.add(todo)
            }
            
            self.dismiss(animated: true, completion: nil)
        } catch {
            NSLog("Realm error", error.localizedDescription)
        }
    }
    

    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// called in HomeViewController after AddViewController dismissed
extension AddViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag , completion: completion)
        guard let presentationController = self.navigationController?.presentationController else {
            return }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
