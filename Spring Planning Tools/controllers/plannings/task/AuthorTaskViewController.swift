//
//  AuthorTaskViewController.swift
//  Spring Planning Tools
//
//  Created by mendel bellaiche on 24/06/2020.
//  Copyright © 2020 mendel bellaiche. All rights reserved.
//

import UIKit

class AuthorTaskViewController: UIViewController {

    var task: Task!
    var author: [Author]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if task != nil {
            print(task.title!)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
