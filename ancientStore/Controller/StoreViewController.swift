//
//  StoreViewController.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/25.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    
    let items = AllItemsClass.shared
    let tokens = SavedToken.shared
    var itemData = ItemData.Food
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAllItems()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
    }
    
    @IBAction func showFoodData(_ sender: UIButton) {
        itemData = .Food
        tableView.reloadData()
    }
    @IBAction func showWeaponData(_ sender: UIButton) {
        itemData = .Weapon
        tableView.reloadData()
    }
    @IBAction func showSpecialData(_ sender: UIButton) {
        itemData = .Special
        tableView.reloadData()
    }
    
    
    @IBAction func backToHome(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let addVC = storyboard?.instantiateViewController(withIdentifier: "addVC") as! AddItemViewController
        addVC.mode = .Add
    }
}

extension StoreViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows: Int
        
        switch itemData {
        case .Food:
            numberOfRows = items.sort1.count
        case .Weapon:
            numberOfRows = items.sort2.count
        case .Special:
            numberOfRows = items.sort3.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! ItemTableViewCell
        
        switch itemData {
        case .Food:
            cell.itemNameLabel.text = "名稱：\(items.sort1[indexPath.item].item_name)"
            cell.itemPriceLabel.text = "售價：\(items.sort1[indexPath.item].price)"
        case .Weapon:
            cell.itemNameLabel.text = "名稱：\(items.sort2[indexPath.item].item_name)"
            cell.itemPriceLabel.text = "售價：\(items.sort2[indexPath.item].price)"
        case .Special:
            cell.itemNameLabel.text = "名稱：\(items.sort3[indexPath.item].item_name)"
            cell.itemPriceLabel.text = "售價：\(items.sort3[indexPath.item].price)"
        }
        
        cell.itemImageView.image = UIImage(named: "rice")
        return cell
    }
}

extension StoreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editVC = storyboard?.instantiateViewController(withIdentifier: "addVC") as! AddItemViewController
        editVC.mode = .Edit
        
        switch itemData {
        case .Food:
            editVC.itemName = items.sort1[indexPath.item].item_name
            editVC.itemSort = "\(items.sort1[indexPath.item].sort_id)"
            editVC.itemPrice = "\(items.sort1[indexPath.item].price)"
            editVC.item_id = items.sort1[indexPath.item].id
        case .Weapon:
            editVC.itemName = items.sort2[indexPath.item].item_name
            editVC.itemSort = "\(items.sort2[indexPath.item].sort_id)"
            editVC.itemPrice = "\(items.sort2[indexPath.item].price)"
            editVC.item_id = items.sort2[indexPath.item].id
        case .Special:
            editVC.itemName = items.sort3[indexPath.item].item_name
            editVC.itemSort = "\(items.sort3[indexPath.item].sort_id)"
            editVC.itemPrice = "\(items.sort3[indexPath.item].price)"
            editVC.item_id = items.sort3[indexPath.item].id
        }
        navigationController?.pushViewController(editVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除", handler: { (action, view, success) in
            
            let alert = UIAlertController(title: "要刪除嗎？", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                switch self.itemData {
                case .Food:
                    let url = URL(string: "http://35.234.60.173/api/wolf/items/\(self.items.sort1[indexPath.item].id)")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "Delete"
                    request.setValue("Bearer \(self.tokens.savedToken!.api_token!)", forHTTPHeaderField: "Authorization")
                    
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            print ("error: \(error)")
                            return
                        }
                        if let response = response as? HTTPURLResponse {
                            self.getAllItems()
                            print("status code: \(response.statusCode)")
                        }
                    }
                    task.resume()
                case .Weapon:
                    let url = URL(string: "http://35.234.60.173/api/wolf/items/\(self.items.sort2[indexPath.item].id)")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "Delete"
                    request.setValue("Bearer \(self.tokens.savedToken!.api_token!)", forHTTPHeaderField: "Authorization")
                    
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            print ("error: \(error)")
                            return
                        }
                        if let response = response as? HTTPURLResponse {
                            self.getAllItems()
                            print("status code: \(response.statusCode)")
                        }
                    }
                    task.resume()
                case .Special:
                    let url = URL(string: "http://35.234.60.173/api/wolf/items/\(self.items.sort3[indexPath.item].id)")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "Delete"
                    request.setValue("Bearer \(self.tokens.savedToken!.api_token!)", forHTTPHeaderField: "Authorization")
                    
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            print ("error: \(error)")
                            return
                        }
                        if let response = response as? HTTPURLResponse {
                            self.getAllItems()
                            print("status code: \(response.statusCode)")
                        }
                    }
                    task.resume()
                }
            }))
            alert.addAction(UIAlertAction(title: "不要", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension StoreViewController {
    
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
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.activityIndicatorView.removeFromSuperview()
                    }
                } catch {
                    print(error.localizedDescription)
                    let string = String(data: data, encoding: .utf8)
                    print(string!)
                }
            }.resume()
        }
    }
}
