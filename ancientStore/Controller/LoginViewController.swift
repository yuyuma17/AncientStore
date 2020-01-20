//
//  LoginViewController.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/25.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let tokens = SavedToken.shared
    var gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var loginOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        accountTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        HttpManager().post(url: URL(string: Url.baseUrl + "wolf/login")!, account: accountTextField.text!, password: passwordTextField.text!) { (data, response, error) in
            
            if let error = error {
                print ("error: \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("status code: \(response.statusCode)")
                DispatchQueue.main.async {
                    
                    if response.statusCode == 200 {
                        let alert = UIAlertController(title: "登入成功！", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                            if let storeNavi = self.storyboard?.instantiateViewController(withIdentifier: "HomeNaviVC") as? UINavigationController {
                                if let destination = storeNavi.viewControllers.first as? HomeViewController {
                                    
                                    self.decodeData(data!)
                                    self.present(storeNavi, animated: true, completion: nil)
                                }
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "帳號或密碼錯誤！", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
        }
//        ownerLogin()
    }
    
    // 點擊空白收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == accountTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.endEditing(true)
        }
        return true
    }
    
    func buttonAnimation() {
        
        //設置漸層顏色
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.85).cgColor,
                                UIColor.white.withAlphaComponent(1).cgColor,
                                UIColor.black.withAlphaComponent(0.85).cgColor]
        
        //設置每個顏色漸變的點0.0~1.0
        gradientLayer.locations = [0, 0, 0.1]
        //漸層起始和結束位置
        gradientLayer.startPoint = CGPoint(x:0, y:0)
        gradientLayer.endPoint = CGPoint(x:1, y:0)
        //Layer大小等於標籤的邊界
        gradientLayer.frame = loginOutlet.bounds
        
        //設定動畫，讓顏色由右至左
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0, 0, 0.2]
        gradientAnimation.toValue = [0.9 , 1, 1]
        gradientAnimation.isRemovedOnCompletion = false
        gradientAnimation.duration = 2.0
        //重複執行
        gradientAnimation.repeatCount = HUGE
        gradientAnimation.fillMode = .forwards
        //將動畫加在CAGradientLayer上
        gradientLayer.add(gradientAnimation,forKey: nil)
        //套用CAGradientLayer
        loginOutlet.layer.mask = gradientLayer
    }
}

extension LoginViewController {
    
    func ownerLogin() {
        
        let passingData = LoginRequired(account: accountTextField.text!, password: passwordTextField.text!)
        guard let uploadData = try? JSONEncoder().encode(passingData) else { return }
        
        let url = URL(string: Url.baseUrl + "wolf/login")!
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
                    
                    if response.statusCode == 200 {
                        let alert = UIAlertController(title: "登入成功！", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                            if let storeNavi = self.storyboard?.instantiateViewController(withIdentifier: "HomeNaviVC") as? UINavigationController {
                                if let destination = storeNavi.viewControllers.first as? HomeViewController {
                                    
                                    self.decodeData(data!)
                                    self.present(storeNavi, animated: true, completion: nil)
                                }
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "帳號或密碼錯誤！", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    func decodeData(_ data: Data) {
        let decoder = JSONDecoder()
        if let data = try? decoder.decode(LoginReceived.self, from: data) {
            tokens.savedToken = data.now_flower
        }
    }
}
