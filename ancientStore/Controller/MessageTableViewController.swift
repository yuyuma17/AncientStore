//
//  MessageTableViewController.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/12/9.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {
    
    var allMsg: ReceiveAllmsg?
    let tokens = SavedToken.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAllMessages()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if allMsg?.allmsg[indexPath.row].wolf_msg == nil {
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "回覆這則留言", message: nil, preferredStyle: .alert)
            
            let sendAction = UIAlertAction(title: "送出", style: .default) { (UIAlertAction) in
                
                if textField.text!.count >= 1 {
                    
                    let passingData = SendMessage(id: "\(self.allMsg!.allmsg[indexPath.row].id)", wolf_msg: textField.text!)
                    guard let uploadData = try? JSONEncoder().encode(passingData) else { return }
                    
                    let url = URL(string: "http://35.234.60.173/api/wolfreplay")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
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
                            self.getAllMessages()
                        }
                    }
                    task.resume()
                }
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alert.addTextField { (UITextField) in
                UITextField.placeholder = "寫些東西給買家吧～"
                textField = UITextField
            }
            
            alert.addAction(sendAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        } else {
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allMsg?.allmsg.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        
        cell.buyerNameLabel.text = allMsg?.allmsg[indexPath.row].name
        cell.buyerMessageTextField.text = allMsg?.allmsg[indexPath.row].sheep_msg
        
        if allMsg?.allmsg[indexPath.row].type == "fire" {
            cell.buyerImageView.image = UIImage(named: "Grass01-小火龍")
        } else if allMsg?.allmsg[indexPath.row].type == "grass" {
            cell.buyerImageView.image = UIImage(named: "Grass01-妙蛙")
        } else if allMsg?.allmsg[indexPath.row].type == "water" {
            cell.buyerImageView.image = UIImage(named: "Grass01-傑尼龜")
        } else {
            cell.buyerImageView.image = UIImage(named: "Grass01-妙蛙")
        }
        
        if allMsg?.allmsg[indexPath.row].wolf_msg != nil {
            cell.sellerImageView.image = UIImage(named: "Grass01-皮卡丘")
            cell.sellerMessageTextField.text = allMsg?.allmsg[indexPath.row].wolf_msg
        } else {
            cell.sellerImageView.image = UIImage(named: "wolf")
            cell.sellerMessageTextField.text = "尚未回覆"
        }
        
        if (allMsg?.allmsg[indexPath.row].score)! >= 3000 {
            cell.vipImageView.isHidden = false
        } else {
            cell.vipImageView.isHidden = true
        }
        
        return cell
    }
}

extension MessageTableViewController {
    
    func getAllMessages() {
        
        let url = URL(string: "http://35.234.60.173/api/allmsg")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.tokens.savedToken!.api_token!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
            
            if let response = response as? HTTPURLResponse {
                print("status code: \(response.statusCode)")
            }
            
            guard let data = data else { return }
            do {
                let tryCatchData = try JSONDecoder().decode(ReceiveAllmsg.self, from: data)
                self.allMsg = tryCatchData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
                let string = String(data: data, encoding: .utf8)
                print(string!)
            }
        }
        task.resume()
    }
}
