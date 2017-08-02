//
//  GoodsUnitController.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/8/2.
//
//

import Foundation
import Vapor
import HTTP

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

final class GoodsUnitController: ResourceRepresentable {
    
    /// GET /goodsUnit
    func index(_ req: Request) throws -> ResponseRepresentable {
        
        let user = try req.user()
        guard let json = try user?.goodsUnits.all().makeJSON() else {
            return AppResponse(code: AppResponseCode.success)
        }
        
        
        return AppResponse(data: json)
    }
    
    /// POST /goodsUnit
    func create(_ req: Request) throws -> ResponseRepresentable {
        
        guard let id = try req.user()?.id else {
            throw Abort.unauthorized
        }
        
        let unit = try req.goodsUnit()
        
        let cs = try GoodsUnit.makeQuery().and { group in
            try group.filter("name", .equals, unit.name)
            try group.filter("user_id", .equals, id)
        }
        if let _  = try cs.first() {
            return AppResponse(code: GoodsUnitResponseCode.unitExist)
        } else {
            unit.userId = id
            try unit.save()
            return AppResponse(data: try unit.makeJSON())
        }
        
    }
    
    /// DELETE /goodsCategory/13rd88
    func delete(_ req: Request, unit: GoodsUnit) throws -> ResponseRepresentable {
        try unit.delete()
        return AppResponse()
    }
    
    
    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this
    /// implementation
    func makeResource() -> Resource<GoodsUnit> {
        return Resource(
            index: index,
            store: create,
            destroy: delete
        )
    }
}

extension Request {
    /// Create a GoodsCategory from the JSON body
    /// return BadRequest error if invalid
    /// or no JSON
    func goodsUnit() throws -> GoodsUnit {
        guard let json = json else { throw Abort.badRequest }
        return try GoodsUnit(json: json)
    }
}

/// Since GoodsCategoryController doesn't require anything to
/// be initialized we can conform it to EmptyInitializable.
///
/// This will allow it to be passed by type.
extension GoodsUnitController: EmptyInitializable { }






