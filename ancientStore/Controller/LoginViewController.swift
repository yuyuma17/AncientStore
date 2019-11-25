//
//  LoginViewController.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/25.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        accountTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func login(_ sender: UIButton) {
        ownerLogin()
    }
    
    // 點擊空白收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginViewController {
    
    func ownerLogin() {
        
        let passingData = loginRequired(account: accountTextField.text!, password: passwordTextField.text!)
        guard let uploadData = try? JSONEncoder().encode(passingData) else { return }
                
        let url = URL(string: "http://5c390001.ngrok.io/api/wolf/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
                
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("status code: \(response.statusCode)")
                DispatchQueue.main.async {
                    if response.statusCode == 404 {
                        let alert = UIAlertController(title: "帳號或密碼錯誤！", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "登入成功！", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                            if let storeNavi = self.storyboard?.instantiateViewController(withIdentifier: "StoreNaviVC") as? UINavigationController {
                                if let destination = storeNavi.viewControllers.first as? StoreViewController {
                                    self.present(storeNavi, animated: true, completion: nil)
                                }
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        task.resume()
    }
}
