//
//  AddItemViewController.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/25.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {
    
    var mode = Mode.Add
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "新增成功", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "好", style: .default) { (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    
    
    
    
    
    
}
