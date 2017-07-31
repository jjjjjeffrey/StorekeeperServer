//
//  AuthenticationMiddleware.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/7/26.
//
//

import HTTP
import Vapor
import JWT

enum RedisCache {
    case userToken(String)
    
    var key: String {
        get {
            switch self {
            case let .userToken(id):
                return "user:\(id)token"
            }
        }
    }
    
    func get() throws -> Node? {
        return try App.share.drop.cache.get(key)
    }
    
    func set(_ value: NodeRepresentable, expiration: Date? = nil) throws {
        return try App.share.drop.cache.set(key, value, expiration: expiration)
    }
}

final class AuthenticationMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        guard let token = request.headers["token"] else {
            throw Abort.unauthorized
        }
        
        guard let id = try JWT(token: token).payload["id"]?.string else {
            throw Abort.unauthorized
        }
        
        guard let cacheToken = try RedisCache.userToken(id).get()?.string, token == cacheToken else {
            throw Abort.unauthorized
        }
        
        let response = try next.respond(to: request)
        return response
    }
}
