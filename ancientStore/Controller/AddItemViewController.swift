//
//  AddItemViewController.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/25.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let tokens = SavedToken.shared
    var mode = Mode.Add
    let imagePicker = UIImagePickerController()
    
    var itemName: String?
    var itemSort: String?
    var itemPrice: String?
    var item_id: Int?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemSortTextField: UITextField!
    @IBOutlet weak var itemPriceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        navigationItem.title = mode.navigationTitle
        
        if mode == Mode.Edit {
            itemNameTextField.text = itemName
            itemSortTextField.text = itemSort
            itemPriceTextField.text = itemPrice
            backgroundImageView.image = UIImage(named: "background3")
        }
    }
    
    // 點擊空白收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
            addNewItem()
            let alert = UIAlertController(title: "新增成功", message: "", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "好", style: .default) { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(alertAction)
            present(alert, animated: true)
        case .Edit:
            reviseItem()
            let alert = UIAlertController(title: "修改成功", message: "", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "好", style: .default) { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(alertAction)
            present(alert, animated: true)
        }
    }
}

extension AddItemViewController {
    
    func addNewItem() {
        
        let passingData = AddNewItemRequired(item_name: itemNameTextField.text!, sort_id: itemSortTextField.text!, price: itemPriceTextField.text!)
        guard let uploadData = try? JSONEncoder().encode(passingData) else { return }
        
        let url = URL(string: "http://35.234.60.173/api/wolf/items")!
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(self.tokens.savedToken!.api_token!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("status code: \(response.statusCode)")
            }
        }
        task.resume()
    }
    
    func reviseItem() {
        
        let passingData = AddNewItemRequired(item_name: itemNameTextField.text!, sort_id: itemSortTextField.text!, price: itemPriceTextField.text!)
        guard let uploadData = try? JSONEncoder().encode(passingData) else { return }
        
        let url = URL(string: "http://35.234.60.173/api/wolf/items/\(item_id!)")!
        var request = URLRequest(url: url)
        request.httpMethod = "Put"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(self.tokens.savedToken!.api_token!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("status code: \(response.statusCode)")
            }
        }
        task.resume()
    }
    
    func uploadPic() {
        
    }
}
