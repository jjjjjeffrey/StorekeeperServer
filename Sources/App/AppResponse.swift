//
//  AppResponse.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/7/25.
//
//

import Foundation

protocol CustomResponsCode: CustomStringConvertible {
    var rawValue: Int { get }
}

enum AppResponseCode: Int, CustomResponsCode {
    case success
    case parameterError = 101
    case neteaseApiError = 102
    
    var description: String {
        get {
            switch self {
            case .success: return "请求成功"
            case .parameterError: return "参数错误"
            case .neteaseApiError: return "网易云错误"
            }
        }
    }
}

struct AppResponse: ResponseRepresentable {
    let code: CustomResponsCode
    let data: JSON?
    
    init(code: CustomResponsCode = AppResponseCode.success, data: JSON? = nil) {
        self.code = code
        self.data = data
    }
    
    func makeResponse() throws -> Response {
        var json = JSON()
        try json.set("code", code.rawValue)
        try json.set("data", data)
        try json.set("message", code.description)
        return try json.makeResponse()
    }
}

enum PassportResponseCode: Int, CustomResponsCode {
    case userExist = 1001
    case userOrPassError = 1002
    
    var description: String {
        get {
            switch self {
            case .userExist: return "用户已存在"
            case .userOrPassError: return "用户名或密码错误"
            }
        }
    }
}

enum GoodsCategoryResponseCode: Int, CustomResponsCode {
    case categoryExist = 1101
    
    var description: String {
        get {
            switch self {
            case .categoryExist: return "该分类已存在"
            }
        }
    }
}

enum GoodsUnitResponseCode: Int, CustomResponsCode {
    case unitExist = 1201
    
    var description: String {
        get {
            switch self {
            case .unitExist: return "该单位已存在"
            }
        }
    }
}

enum GoodsResponseCode: Int, CustomResponsCode {
    case goodsExist = 1301
    
    var description: String {
        get {
            switch self {
            case .goodsExist: return "该商品已存在"
            }
        }
    }
}



