//
//  AddItemViewController.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/25.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var mode = Mode.Add
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        navigationItem.title = mode.navigationTitle
        
        if mode == Mode.Add {
            backgroundImageView.image = UIImage(named: "background4")
        } else {
            backgroundImageView.image = UIImage(named: "background3")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        itemImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func photoAPic(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    @IBAction func selectAPic(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        switch mode {
            
        case .Add:
            let alert = UIAlertController(title: "新增成功", message: "", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "好", style: .default) { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(alertAction)
            present(alert, animated: true)
        case .Edit:
            let alert = UIAlertController(title: "修改成功", message: "", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "好", style: .default) { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(alertAction)
            present(alert, animated: true)
        }
    }
}
