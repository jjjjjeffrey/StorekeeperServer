//
//  GoodsController.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/8/2.
//
//

import Foundation
import Vapor
import HTTP

final class GoodsController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        
        guard let category = req.data["category"]?.string else {
            return AppResponse(data: try req.user().goods.all().makeJSON())
        }
        
        return AppResponse(data: try req.user().goods.filter(Goods.categoryKey, .equals, category).all().makeJSON())
        
    }
    
    func create(_ req: Request) throws -> ResponseRepresentable {
        
        let goods = try req.goods()
        
        let g = try req.user().goods.and { group in
            try group.filter(Goods.nameKey, .equals, goods.name)
            try group.filter(Goods.barCodeKey, .equals, goods.barCode)
        }
        if let _  = try g.first() {
            return AppResponse(code: GoodsResponseCode.goodsExist)
        } else {
            goods.userId = try req.userId()
            try goods.save()
            return AppResponse(data: try goods.makeJSON())
        }
        
    }
    
    func delete(_ req: Request, goods: Goods) throws -> ResponseRepresentable {
        try goods.delete()
        return AppResponse()
    }
    
    func makeResource() -> Resource<Goods> {
        return Resource(
            index: index,
            store: create,
            destroy: delete
        )
    }
}

extension Request {

    func goods() throws -> Goods {
        guard let json = json else { throw Abort.badRequest }
        return try Goods(json: json)
    }
    
}

extension GoodsController: EmptyInitializable { }



