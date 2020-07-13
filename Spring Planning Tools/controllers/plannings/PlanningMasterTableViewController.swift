//
//  PlanningMasterTableViewController.swift
//  Spring Planning Tools
//
//  Created by mendel bellaiche on 23/06/2020.
//  Copyright © 2020 mendel bellaiche. All rights reserved.
//

import UIKit
import CoreData

class PlanningMasterTableViewController: UITableViewController {

    var plannings: [Planning]?
    var delegate: PlanningProtocol?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(onPlanningDetailDeleted(_:)), name: .planningDeleted, object: nil)
        
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.plannings!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.planningCell, for: indexPath)
        
        let planning = self.plannings![indexPath.row]
        cell.textLabel?.text = planning.title!
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let action1 = UIContextualAction(style: .normal, title: "Edit",
          handler: { (action, view, completionHandler) in
            
            let alertRename = UIAlertController(title: "", message: "What is the name of your Planning ?", preferredStyle: .alert)
            alertRename.addTextField() { tf in
                tf.placeholder = "Name of Planning"
                tf.text = self.plannings![indexPath.row].title!
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { action in
                let tf = alertRename.textFields![0]
                
                let planningId = self.plannings![indexPath.row].id
                CoreDataHelper.shared.updatePlanning(idPlanning: planningId!, title: tf.text!)
                
                self.tableView.reloadData()
                
            }
            alertRename.addAction(saveAction)
            
            alertRename.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alertRename, animated: true, completion: nil)
            completionHandler(true)
        })
        
        action1.image = UIImage(systemName: "pencil")
        action1.backgroundColor = .systemBlue
        
        let action2 = UIContextualAction(style: .normal, title: "Send",
          handler: { (action, view, completionHandler) in
            
            print("send by email")
            completionHandler(true)
        })
        
        action2.image = UIImage(systemName: "square.and.arrow.up")
        action2.backgroundColor = .lightGray
        
        let configuration = UISwipeActionsConfiguration(actions: [action1, action2])
        return configuration
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataHelper.shared.deletePlanning(with: self.plannings![indexPath.row].id!)
            self.plannings?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            var selectedIndex = indexPath.row-1
            
            if !self.plannings!.isEmpty && selectedIndex < 0 {
                selectedIndex = 0
            }
            
            if selectedIndex < 0 {
                self.delegate!.planningSelected(nil)
            } else {
                self.delegate!.planningSelected(self.plannings![selectedIndex])
            }
        } else if editingStyle == .insert {
            print("insert")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlanning = self.plannings![indexPath.row]
        self.delegate?.planningSelected(selectedPlanning)
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - @IBAction methods
    
    @IBAction func addPlanningBarButtonItemTapped(_ sender: UIBarButtonItem) {
        let planning = CoreDataHelper.shared.createPlanning(title: Constants.newPlanningTitle)
        self.plannings!.append(planning!)
        self.delegate!.planningSelected(planning)
        tableView.reloadData()
    }
    
    @objc func onPlanningDetailDeleted(_ notification:Notification) {
        
        if let data = notification.userInfo as? [String: Planning] {
            for (_, planningToDelete) in data {
                self.plannings!.removeAll { planning in
                    planning.id! == planningToDelete.id
                }
            }
            
            self.delegate?.planningSelected(self.plannings!.first)
            self.tableView.reloadData()
        }
    }
    
}
