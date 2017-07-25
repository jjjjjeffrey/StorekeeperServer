//
//  PassportController.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/7/25.
//
//

import Foundation
import Vapor
import HTTP

enum PassportResponseCode: Int, CustomResponsCode {
    case userExist = 1001
    
    var description: String {
        get {
            switch self {
            case .userExist: return "用户已存在"
            }
        }
    }
}

final class PassportController {
    
    func mobileRegister(_ req: Request) throws -> ResponseRepresentable {
        
        guard let mobile = req.data["mobile"]?.string, let password = req.data["password"]?.string else {
            return AppResponse(code: AppResponseCode.parameterError)
        }
        
        guard let _ = try User.makeQuery().filter("mobile", .equals, mobile).first() else {
            let index = mobile.index(mobile.startIndex, offsetBy: 7)
            let user = User(mobile: mobile, password: password, shopName: mobile.substring(from: index))
            try user.save()
            
            return AppResponse(code: AppResponseCode.success, data: try user.makeJSON())
            
        }
        
        return AppResponse(code: PassportResponseCode.userExist)
    }
    
    
    
}
