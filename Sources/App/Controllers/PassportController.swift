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
import JWT

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

final class PassportController {
    
    func mobileRegister(_ req: Request) throws -> ResponseRepresentable {
        
        guard let mobile = req.data["mobile"]?.string,
            let shopName = req.data["shopName"]?.string,
            let password = req.data["password"]?.string else {
            return AppResponse(code: AppResponseCode.parameterError)
        }
        
        guard let _ = try User.makeQuery().filter("mobile", .equals, mobile).first() else {
            let user = User(mobile: mobile, password: password, shopName: shopName)
            try user.save()
            
            let id = try user.assertExists()
            let goodsCategory = GoodsCategory(name: "默认分类")
            goodsCategory.userId = id
            try goodsCategory.save()
            
            
            return AppResponse(data: try user.makeJSON())
            
        }
        
        return AppResponse(code: PassportResponseCode.userExist)
    }
    
    func mobileLogin(_ req: Request) throws -> ResponseRepresentable {
        
        guard let mobile = req.data["mobile"]?.string, let password = req.data["password"]?.string else {
            return AppResponse(code: AppResponseCode.parameterError)
        }
        
        let users = try User.makeQuery().and { (group) in
            try group.filter("mobile", .equals, mobile)
            try group.filter("password", .equals, password)
        }
        
        guard let user = try users.first(), let id = user.id?.string else {
            return AppResponse(code: PassportResponseCode.userOrPassError)
        }
        
        var payload = JSON()
        try payload.set("timestamp", Date().timeIntervalSince1970)
        try payload.set("id", id)
        let jwt = try JWT(payload: payload, signer: SKSigner())
        let token = try jwt.createToken()
        
        try RedisCache.userToken(id).set(token)

        var json = try user.makeJSON()
        try json.set("token", token)
        return AppResponse(data: json)
    }
    
    func getUserInfo(_ req: Request) throws -> ResponseRepresentable {
        
        guard let user = try req.user() else {
            throw Abort.unauthorized
        }
        
        
        return AppResponse(data: try user.makeJSON())
    }
    
}

extension Request {
    
    func user() throws -> User? {
        guard let token = headers["token"] else {
            return nil
        }
        
        guard let id = try JWT(token: token).payload["id"]?.string else {
            return nil
        }
        
        guard let user = try User.find(id) else {
            return nil
        }
        
        return user
    }
    
}

struct SKSigner: Signer {
    let name = "storekeeper"
    
    func sign(message: Bytes) throws -> Bytes {
        return [126] + message + [126]
    }
    
    func verify(signature: Bytes, message: Bytes) throws {
        guard try signature == sign(message: message) else {
            throw JWTError.signatureVerificationFailed
        }
    }
}
