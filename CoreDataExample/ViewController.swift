//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Ravi Tripathi on 13/12/19.
//  Copyright © 2019 Ravi Tripathi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var inputVC: UIViewController?
    var tableViewVC: UITableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inputSegue" {
            self.inputVC = segue.destination
        } else if segue.identifier == "outputSegue" {
            self.tableViewVC = (segue.destination as! UITableViewController)
        }
    }


}

