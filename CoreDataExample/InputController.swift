//
//  InputController.swift
//  CoreDataExample
//
//  Created by Ravi Tripathi on 13/12/19.
//  Copyright © 2019 Ravi Tripathi. All rights reserved.
//

import UIKit

class InputController: UIViewController {
    
    @IBOutlet weak var itemNameTextField: UITextField!
    
    
    @IBOutlet weak var priceLabel: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func didSubmit(_ sender: UIButton) {
        guard let itemName = itemNameTextField.text, !itemName.isEmpty, let price = priceLabel.text, !price.isEmpty, let priceVal = Double(price) else {
            return
        }
        print("\(itemName)\(price)")
        let data = DataModel(billNumber: "123", title: itemName, amount: priceVal)
        CoreDataManager.save(data: data)
    }
    
    
    
}
