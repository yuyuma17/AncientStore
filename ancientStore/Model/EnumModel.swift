//
//  EnumModel.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/25.
//  Copyright © 2019 Lacie. All rights reserved.
//

import Foundation

enum Mode {
    
    case Add
    case Edit
    
    var navigationTitle: String {
        switch self {
        case .Add:
            return "新增商品"
        case .Edit:
            return "編輯商品"
        }
    }
}

enum ItemData {
    
    case Food
    case Weapon
    case Special
    
}

enum PicWay {
    
    case Camera
    case Album
    
}
