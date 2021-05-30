//
//  EditViewController.swift
//  ToDoApp
//
//  Created by Taro on 2021/05/30.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    var todoItem: ToDoModel?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit"
        
        self.titleTextField.text = todoItem?.title ?? ""
        
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
        self.saveButton.isSelected = !isEmpty
        self.saveButton.alpha = isEmpty ? 0.5 : 1.0
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        guard let todoItem = self.todoItem else { return }
        
        do {
            let realm = try Realm()
            try realm.write {
                todoItem.title = self.titleTextField.text ?? ""
            }
        } catch {
            NSLog("Realm error", error.localizedDescription)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// called in HomeViewController after EditViewController dismissed
extension EditViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag , completion: completion)
        guard let presentationController = self.navigationController?.presentationController else {
            return }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
