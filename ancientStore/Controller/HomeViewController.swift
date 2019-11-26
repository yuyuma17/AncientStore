//
//  HomeViewController.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/26.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var allSales: ReceiveSaleInfor?
    
    let items = AllItemsClass.shared
    let tokens = SavedToken.shared
    
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var saleItemLabel: UILabel!
    @IBOutlet weak var homeLVLabel: UILabel!
    @IBOutlet weak var homeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllItems()
        getSaleInfor()
    }
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController {
    
    func getSaleInfor() {
        
        
        let url = URL(string: "http://35.234.60.173/api/wolfitem")!
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
                let tryCatchData = try JSONDecoder().decode(ReceiveSaleInfor.self, from: data)
                self.allSales = tryCatchData
                
                DispatchQueue.main.async {
                    self.revenueLabel.text = "累積銷售金額為：\(self.allSales!.all_total) 元"
                    self.saleItemLabel.text = "累積銷售貨物數量為： \(self.allSales!.all_stock) 個"
                    self.homeLVLabel.text = "主城等級為：\(self.allSales!.lv) 級"
                    
                    if self.allSales!.lv == 1 {
                        self.homeImageView.image = UIImage(named: "Home1")
                    } else if self.allSales!.lv == 2 {
                        self.homeImageView.image = UIImage(named: "Home2")
                    } else if self.allSales!.lv == 3 {
                        self.homeImageView.image = UIImage(named: "Home3")
                    } else if self.allSales!.lv == 4 {
                        self.homeImageView.image = UIImage(named: "Home4")
                    } else if self.allSales!.lv == 5 {
                        self.homeImageView.image = UIImage(named: "Home5")
                    }
                }
            } catch {
                print(error.localizedDescription)
                let string = String(data: data, encoding: .utf8)
                print(string!)
            }
        }
        task.resume()
    }
    
    func getAllItems() {
        
        if let url = URL(string: "http://35.234.60.173/api/items") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                }
                
                if let response = response as? HTTPURLResponse {
                    print("status code: \(response.statusCode)")
                }
                
                guard let data = data else { return }
                do {
                    let tryCatchData = try JSONDecoder().decode(AllItemsStruct.self, from: data)
                    self.items.allItems = tryCatchData.items
                } catch {
                    print(error.localizedDescription)
                    let string = String(data: data, encoding: .utf8)
                    print(string!)
                }
            }.resume()
        }
    }
}
