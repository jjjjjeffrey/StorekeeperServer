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
