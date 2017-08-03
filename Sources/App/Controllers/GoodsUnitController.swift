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



final class GoodsUnitController: ResourceRepresentable {
    
    /// GET /goodsUnit
    func index(_ req: Request) throws -> ResponseRepresentable {

        return AppResponse(data: try req.user().goodsUnits.all().makeJSON())
        
    }
    
    /// POST /goodsUnit
    func create(_ req: Request) throws -> ResponseRepresentable {
        
        let unit = try req.goodsUnit()
        
        let cs = try req.user().goodsUnits.filter(GoodsUnit.nameKey, .equals, unit.name)
        if let _  = try cs.first() {
            return AppResponse(code: GoodsUnitResponseCode.unitExist)
        } else {
            unit.userId = try req.userId()
            try unit.save()
            return AppResponse(data: try unit.makeJSON())
        }
        
    }
    
    /// DELETE /goodsUnit/13rd88
    func delete(_ req: Request, unit: GoodsUnit) throws -> ResponseRepresentable {
        try unit.delete()
        return AppResponse()
    }
    
    func makeResource() -> Resource<GoodsUnit> {
        return Resource(
            index: index,
            store: create,
            destroy: delete
        )
    }
}

extension Request {
    func goodsUnit() throws -> GoodsUnit {
        guard let json = json else { throw Abort.badRequest }
        return try GoodsUnit(json: json)
    }
}

extension GoodsUnitController: EmptyInitializable { }






