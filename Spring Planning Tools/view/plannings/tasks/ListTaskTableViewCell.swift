//
//  ListTaskTableViewCell.swift
//  Spring Planning Tools
//
//  Created by mendel bellaiche on 23/06/2020.
//  Copyright © 2020 mendel bellaiche. All rights reserved.
//

import UIKit

class ListTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var etatLabel: UILabel!
    
    var task: Task! {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateUI() {
        self.titleLabel.text = task.title!
        self.etatLabel.text = self.getEtatStr(etat: Int(task.etat))
        if Int(task.etat) == Etat.done.rawValue {
            self.etatLabel.textColor = .systemGreen
        } else if Int(task.etat) == Etat.inprogress.rawValue {
            self.etatLabel.textColor = .systemOrange
        } else {
            self.etatLabel.textColor = .black
        }
        self.priorityView.backgroundColor = self.getPriorityColor(priority: Int(task.priority))
    }
    
    func getEtatStr(etat: Int) -> String {
        if etat == Etat.undone.rawValue {
            return "Undone"
        } else if etat == Etat.inprogress.rawValue {
            return "In progress"
        } else if etat == Etat.done.rawValue {
            return "Done"
        }
        return "-"
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
