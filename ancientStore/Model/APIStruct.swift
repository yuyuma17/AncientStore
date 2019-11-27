//
//  APIStruct.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/25.
//  Copyright © 2019 Lacie. All rights reserved.
//

import Foundation

struct LoginRequired: Codable {
    
    let account: String
    let password: String
    
}

struct GetBankRequired: Codable {
    
    let userID: String
    let key: String
    
}

struct LoginReceived: Codable {
    
    let now_flower: LoginReceivedInfor
    
    struct LoginReceivedInfor: Codable {
        
        var api_token: String?
        let balance: Int
        
    }
}

struct GetBankInfor: Codable {
    
    let message: Message
    
    struct Message: Codable {
        
        let balance: Int
        let level: Int
        
    }
}

class SavedToken {
    
    static let shared = SavedToken()
    var savedToken: LoginReceived.LoginReceivedInfor?
    
}

struct AddNewItemRequired: Codable {
    
    let item_name: String
    let sort_id: String
    let price : String
    let stock: String
    
}

struct AllItemsStruct: Codable {
    
    let items: [Items]
    
    struct Items: Codable {
        
        let id: Int
        let sort_id: Int
        let item_name: String
        let price: Int
        let stock: Int?
        let pic: URL?
        let created_at: String
        let updated_at: String
        
    }
}

class AllItemsClass {
    
    static let shared = AllItemsClass()
    
    var allItems: [AllItemsStruct.Items]?
    
    var sort1: [AllItemsStruct.Items] {
        return allItems!.filter {($0.sort_id == 1)}
    }
    
    var sort2: [AllItemsStruct.Items] {
        return allItems!.filter {($0.sort_id == 2)}
    }
    
    var sort3: [AllItemsStruct.Items] {
        return allItems!.filter {($0.sort_id == 3)}
    }
    
    private init() {}
}

struct ReceiveSaleInfor: Codable {
    
    let lv: Int
    let all_stock: Int
    let all_total: Int
    
}
