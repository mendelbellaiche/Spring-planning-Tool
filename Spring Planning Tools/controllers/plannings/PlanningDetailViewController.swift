//
//  PlanningDetailViewController.swift
//  Spring Planning Tools
//
//  Created by mendel bellaiche on 23/06/2020.
//  Copyright © 2020 mendel bellaiche. All rights reserved.
//

import UIKit
import CoreData

class PlanningDetailViewController: UIViewController {

    var planning: Planning? {
        didSet {
            if self.planning != nil {
                self.updateUI()
            } else {
                self.resetUI()
            }
        }
    }
    
    var tasks: [Task]?
    
    // MARK: - @IBOutelts
    
    @IBOutlet weak var deleteBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var authorBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var addTaskBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var taskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.taskTableView.delegate = self
        self.taskTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTaskDetailUpdated(_:)), name: .taskUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onTaskDetailDeleted(_:)), name: .taskDeleted, object: nil)
        
    }
    
    func resetUI() {
        self.navigationItem.title = ""
        self.updateBarButtons(isEnable: false)
    }
    
    func updateUI() {
        self.navigationItem.title = self.planning!.title!
        self.updateBarButtons(isEnable: true)
    }
    
    func updateTaskTable() {
        self.tasks = self.planning!.tasks?.allObjects as? [Task]
        self.tasks = self.tasks!.sorted(by: { t1, t2 in
            t1.createdDate! > t2.createdDate!
        })
        
        if self.taskTableView != nil {
            self.taskTableView.reloadData()
        }
    }
    
    func updateBarButtons(isEnable: Bool) {
        self.addTaskBarButtonItem.isEnabled = isEnable
        self.deleteBarButtonItem.isEnabled = isEnable
        self.authorBarButtonItem.isEnabled = isEnable
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if segue.identifier == Constants.taskDetailSegue {
            if let vc = segue.destination as? TaskDetailViewController {
                vc.task = sender as? Task
            }
        }
        
    }
    
    
    // MARK: - @IBAction methods
    
    @IBAction func addTaskBarButtonItemTapped(_ sender: UIBarButtonItem) {
        _ = CoreDataHelper.shared.createTask(idPlanning: self.planning!.id!, title: "New Task", priority: Int(Priority.low.rawValue), etat: Int(Etat.undone.rawValue))
        
        self.updateTaskTable()
    }
    
    @IBAction func deleteBarButtonItemTapped(_ sender: UIBarButtonItem) {
        let planningToDelete = self.planning!
        
        self.tasks = nil
        self.taskTableView.reloadData()
        
        NotificationCenter.default.post(name: .planningDeleted, object: self, userInfo: ["planning": planningToDelete])
        
        CoreDataHelper.shared.deletePlanning(with: planningToDelete.id!)
        
    }
    

    @IBAction func authorBarButtonItemTapped(_ sender: UIBarButtonItem) {
    }
    
    
    @objc func onTaskDetailUpdated(_ notification:Notification) {
        self.taskTableView.reloadData()
    }
    
    @objc func onTaskDetailDeleted(_ notification:Notification) {
        self.updateTaskTable()
        self.taskTableView.reloadData()
    }
    
}

// MARK: - PlanningDetailViewController Extensions

extension PlanningDetailViewController: PlanningProtocol {
    
    func planningSelected(_ newPlanning: Planning?) {
        self.planning = newPlanning
        if self.planning != nil {
            self.updateTaskTable()
        }

    }
    
}

extension PlanningDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.planning != nil && self.tasks != nil {
            return self.tasks!.count
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskCell, for: indexPath) as? ListTaskTableViewCell
        
        if self.planning != nil && self.tasks != nil {
            cell?.task = self.tasks![indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.taskDetailSegue, sender: self.tasks![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
