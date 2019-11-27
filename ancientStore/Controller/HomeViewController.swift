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
    
    var gradientLayer = CAGradientLayer()
    let items = AllItemsClass.shared
    let tokens = SavedToken.shared
    
    @IBOutlet weak var enterStoreOutlet: UIButton!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var saleItemLabel: UILabel!
    @IBOutlet weak var homeLVLabel: UILabel!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 10)
        
        getAllItems()
        getSaleInfor()
        buttonAnimation()
    }
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
        gradientLayer.frame = enterStoreOutlet.bounds
        
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
        enterStoreOutlet.layer.mask = gradientLayer
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
                    
                    if self.allSales!.lv == 5 {
                        self.homeLVLabel.text = "主城等級為：\(self.allSales!.lv) 級（已滿級）"
                    } else {
                        self.homeLVLabel.text = "主城等級為：\(self.allSales!.lv) 級"
                    }
                    
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
