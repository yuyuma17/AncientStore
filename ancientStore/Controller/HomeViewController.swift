//
//  HomeViewController.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/26.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let items = AllItemsClass.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllItems()
    }
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController {
    
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
