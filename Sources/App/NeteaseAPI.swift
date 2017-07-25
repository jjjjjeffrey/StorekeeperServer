//
//  NeteaseAPI.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/7/25.
//
//

import Foundation
import Vapor
import HTTP

struct NeteaseAPI {
    
    static var headers: [HeaderKey: String] {
        get {
            let appkey = "2d1713dc04ad9d4ed247a66883951c1d"
            let nonce = randomCustom(min: 0, max: 10000)
            let curTime = Int(Date().timeIntervalSince1970)
            let appSecret = "578629c4bd3e"
            let checksum = "\(appSecret)\(nonce)\(curTime)".sha1()
            
            let headers: [HeaderKey: String] =
                ["AppKey": appkey,
                 "Nonce": "\(nonce)",
                "CurTime": "\(curTime)",
                "CheckSum": "\(checksum)"]
            return headers
        }
    }
    
    static func sendCodeTo(mobile: String) throws -> Response {
        let req = Request(method: .post, uri: "https://api.netease.im/sms/sendcode.action", headers: headers)
        req.formURLEncoded = try Node(node: ["mobile": mobile])
        print("\(req.description)")
        return try App.share.drop.client.respond(to: req)
    }
    
    static func authCode(code: String, mobile: String) throws -> Response {
        let req = Request(method: .post, uri: "https://api.netease.im/sms/verifycode.action", headers: headers)
        req.formURLEncoded = try Node(node: ["mobile": mobile, "code": code])
        print("\(req.description)")
        return try App.share.drop.client.respond(to: req)
    }
    
    static func randomCustom(min: Int, max: Int) -> Int {
        let y = arc4random() % UInt32(max) + UInt32(min)
        return Int(y)
    }
    
}
