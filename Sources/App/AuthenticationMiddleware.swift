//
//  AuthenticationMiddleware.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/7/26.
//
//

import HTTP
import Vapor

final class AuthenticationMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        guard let token = request.headers["token"] else {
            throw Abort.unauthorized
        }
        
        guard let _: String = try App.share.drop.cache.get("tokens:\(token)")?.get() else {
            throw Abort.unauthorized
        }
        
        let response = try next.respond(to: request)
        return response
    }
}
