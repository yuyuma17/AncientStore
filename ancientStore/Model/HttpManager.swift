//
//  HttpManager.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/12/6.
//  Copyright © 2019 Lacie. All rights reserved.
//

import Foundation

class HttpManager {
    
    typealias completeClosure = ( _ data: Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void
    
    func post(url: URL, account: String, password: String, callback: @escaping completeClosure) {
        
        let passingData = LoginRequired(account: account, password: password)
        guard let uploadData = try? JSONEncoder().encode(passingData) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
                        
            callback(data, response as? HTTPURLResponse, error)
        }
        task.resume()
    }
}
