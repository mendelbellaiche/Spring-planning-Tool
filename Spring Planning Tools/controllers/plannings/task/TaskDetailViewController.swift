//
//  TaskDetailViewController.swift
//  Spring Planning Tools
//
//  Created by mendel bellaiche on 23/06/2020.
//  Copyright © 2020 mendel bellaiche. All rights reserved.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController {

    var task: Task!
    var authors: [Author]?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var etatSegmentedControl: UISegmentedControl!
    
    var isDeleting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // self.navigationItem.title = task.title!
        
        self.updateUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isDeleting == false {
            self.saveTask()
        }
        
    }
    
    func updateUI() {
        self.titleTextField.text = self.task.title!
        self.descTextView.text = self.task.desc!

        self.etatSegmentedControl.selectedSegmentIndex = self.getEtatIndex(etat: Int(self.task.etat))
        
        self.prioritySegmentedControl.selectedSegmentIndex = self.getPriorityIndex(priority: Int(self.task.priority))
        self.prioritySegmentedControl.backgroundColor = self.getPriorityColor(priority: Int(self.task.priority))
    }
    
    func saveTask() {
        CoreDataHelper.shared.updateTask(idTask: self.task.id!, title: self.titleTextField.text!, desc: self.descTextView.text, priority: Int(self.prioritySegmentedControl.selectedSegmentIndex), etat: Int(self.etatSegmentedControl.selectedSegmentIndex))
        NotificationCenter.default.post(name: .taskUpdated, object: self, userInfo: ["task": self.task!])
    }

    @IBAction func prioritySegmentedControlValueChanged(_ sender: UISegmentedControl) {
        // self.task.priority = Int16(sender.selectedSegmentIndex)
        sender.backgroundColor = getPriorityColor(priority: sender.selectedSegmentIndex)
    }
    
    @IBAction func etatSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        // self.task.etat = Int16(sender.selectedSegmentIndex)
    }
    
    @IBAction func addPersonBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.authors = self.task.author?.allObjects as? [Author]
        
        let alert = UIAlertController(title: "Author", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            print("Test")
            
            // print("You selected " + self.typeValue )
        
        }))
        self.present(alert,animated: true, completion: nil )
        
    }
    
    @IBAction func deleteTaskBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.isDeleting = true
        CoreDataHelper.shared.deleteTask(with: self.task.id!)
        NotificationCenter.default.post(name: .taskDeleted, object: self, userInfo: ["task": self.task!])
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Constants.personTaskSegue {
            if let vc = segue.destination as? AuthorTaskViewController {
                // vc.task = self.task
                vc.task = self.task
            }
        }
    }
    
    
    
    func getEtatIndex(etat: Int) -> Int {
        if etat == Etat.undone.rawValue {
            return 0
        } else if etat == Etat.inprogress.rawValue {
            return 1
        } else if etat == Etat.done.rawValue {
            return 2
        }
        return 0
    }
    
    func getPriorityIndex(priority: Int) -> Int {
        if priority == Priority.urgent.rawValue {
            return 3
        } else if priority == Priority.high.rawValue {
            return 2
        } else if priority == Priority.medium.rawValue {
            return 1
        } else if priority == Priority.low.rawValue {
            return 0
        }
        return 0
    }
    
    func getPriorityColor(priority: Int) -> UIColor {
        if priority == Priority.urgent.rawValue {
            return UIColor.red
        } else if priority == Priority.high.rawValue {
            return .orange
        } else if priority == Priority.medium.rawValue {
            return .yellow
        } else if priority == Priority.low.rawValue {
            return .white
        }
        return UIColor.clear
    }

}


extension TaskDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.authors!.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0 {
            return "--- No one selected ---"
        } else {
            return self.authors![row-1].fullname
        }
    }
    
    
}
