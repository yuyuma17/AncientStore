//
//  DepositViewController.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/27.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class DepositViewController: UIViewController {
    
    let tokens = SavedToken.shared
    var receivedInfor: GetBankInfor?
    
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var handMoneyLabel: UILabel!
    @IBOutlet weak var bankMoneyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        
        getBankMoney()
        handMoneyLabel.text = "\(tokens.savedToken!.balance) 元"
    }
}

extension DepositViewController {
    
    func getBankMoney() {
        
        let passingData = GetBankRequired(userID: "arcadia@camp.com", key: "956275912")
        guard let uploadData = try? JSONEncoder().encode(passingData) else { return }
        
        let url = URL(string: "https://b555418b.ngrok.io/api/shop/watch")!
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
                self.decodeData(data!)
                DispatchQueue.main.async {
                    self.activityIndicatorView.removeFromSuperview()
                    self.bankMoneyLabel.text = "\(self.receivedInfor!.message.balance) 元"
                }
            }
        }
        task.resume()
    }
    
    func decodeData(_ data: Data) {
        let decoder = JSONDecoder()
        if let data = try? decoder.decode(GetBankInfor.self, from: data) {
            receivedInfor = data
        }
    }
}
