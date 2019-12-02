//
//  AddItemViewController.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/25.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let tokens = SavedToken.shared
    var mode = Mode.Add
    let imagePicker = UIImagePickerController()
    let pickerData = [String](arrayLiteral: "1", "2", "3")
    
    var itemName: String?
    var itemSort: String?
    var itemPrice: String?
    var itemInventory: String?
    var item_id: Int?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemSortTextField: UITextField!
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var itemInventoryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        navigationItem.title = mode.navigationTitle
        
        let thePicker = UIPickerView()
        thePicker.delegate = self
        itemSortTextField.inputView = thePicker
        
        if mode == Mode.Edit {
            itemNameTextField.text = itemName
            itemSortTextField.text = itemSort
            itemPriceTextField.text = itemPrice
            itemInventoryTextField.text = itemInventory
        }
    }
    
    // 點擊空白收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == itemNameTextField {
            itemSortTextField.becomeFirstResponder()
        } else {
            textField.endEditing(true)
        }
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        itemImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UIPickerView Delegation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        itemSortTextField.text = pickerData[row]
    }
    
    @IBAction func selectAPic(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        switch mode {
            
        case .Add:
            
            let image = itemImageView.image
            let imageData = image?.pngData()
            let dataPath = ["pic":imageData!]

            let parameters = [
                "sort_id"  : itemSortTextField.text!,
                "item_name" : itemNameTextField.text!,
                "price" : itemPriceTextField.text!,
                "stock" : itemInventoryTextField.text!,]
            
            requestWithFormData(urlString: "http://35.234.60.173/api/wolf/items", parameters: parameters, dataPath: dataPath) { (Data) in
            }

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
        
        let passingData = AddNewItemRequired(item_name: itemNameTextField.text!, sort_id: itemSortTextField.text!, price: itemPriceTextField.text!, stock: itemInventoryTextField.text!)
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
        
        let passingData = AddNewItemRequired(item_name: itemNameTextField.text!, sort_id: itemSortTextField.text!, price: itemPriceTextField.text!, stock: itemInventoryTextField.text!)
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
    
    func requestWithFormData(urlString: String, parameters: [String: Any], dataPath: [String: Data], completion: @escaping (Data) -> Void){
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary+\(arc4random())\(arc4random())"
        var body = Data()
        
        request.setValue("Bearer \(self.tokens.savedToken!.api_token!)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        for (key, value) in dataPath {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(arc4random())\"\r\n") //此處放入file name，以隨機數代替，可自行放入
            body.appendString(string: "Content-Type: image/png\r\n\r\n") //image/png 可改為其他檔案類型 ex:jpeg
            body.append(value)
            body.appendString(string: "\r\n")
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        request.httpBody = body
        
        fetchedDataByDataTask(from: request, completion: completion)
        
    }
    
    private func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data) -> Void){
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                print("status code: \(response.statusCode)")
            }
            
            if error != nil{
                print(error as Any)
            }else{
                guard let data = data else{return}
                completion(data)
            }
        }
        task.resume()
    }
}

extension Data{
    
    func parseData() -> NSDictionary{
        
        let dataDict = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) as! NSDictionary
        
        return dataDict!
    }
    
    mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
