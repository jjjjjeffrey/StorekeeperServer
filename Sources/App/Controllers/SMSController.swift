//
//  SMSController.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/7/24.
//
//

import Vapor
import HTTP
import Foundation
import CryptoSwift

final class SMSController {
    
    func sendSMSCode(_ req: Request) throws -> ResponseRepresentable {
        
        guard let mobile = req.data["mobile"]?.string else {
            return AppResponse(code: AppResponseCode.parameterError)
        }
        
        do {
            let response = try NeteaseAPI.sendCodeTo(mobile: mobile)
            guard let code = response.json?["code"]?.int, code == 200 else {
                return AppResponse(code: AppResponseCode.neteaseApiError)
            }
            return AppResponse(code: AppResponseCode.success)
        } catch {
            throw Abort.badRequest
        }
        
    }
    
    func authSMSCode(_ req: Request) throws -> ResponseRepresentable {
        
        guard let code = req.data["code"]?.string, let mobile = req.data["mobile"]?.string else {
            return AppResponse(code: AppResponseCode.parameterError)
        }
        
        do {
            let response = try NeteaseAPI.authCode(code: code, mobile: mobile)
            guard let code = response.json?["code"]?.int, code == 200 else {
                return AppResponse(code: AppResponseCode.neteaseApiError)
            }
            return AppResponse(code: AppResponseCode.success)
        } catch {
            throw Abort.badRequest
        }
        
    }
    
}

