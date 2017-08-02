//
//  GoodsController.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/7/28.
//
//

import Foundation
import Vapor
import HTTP

final class GoodsCategoryController: ResourceRepresentable {
    
    /// GET /goodsCategory
    func index(_ req: Request) throws -> ResponseRepresentable {
        return AppResponse(data: try req.user().goodsCategories.all().makeJSON())
    }
    
    /// POST /goodsCategory
    func create(_ req: Request) throws -> ResponseRepresentable {

        let category = try req.goodscategory()
        
        let cs = try req.user().goodsCategories.filter("name", .equals, category.name)
        if let _  = try cs.first() {
            return AppResponse(code: GoodsCategoryResponseCode.categoryExist)
        } else {
            category.userId = try req.userId()
            try category.save()
            return AppResponse(data: try category.makeJSON())
        }
        
    }
    
    /// DELETE /goodsCategory/13rd88
    func delete(_ req: Request, category: GoodsCategory) throws -> ResponseRepresentable {
        try category.delete()
        return AppResponse()
    }
    
    
    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this
    /// implementation
    func makeResource() -> Resource<GoodsCategory> {
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
    func goodscategory() throws -> GoodsCategory {
        guard let json = json else { throw Abort.badRequest }
        return try GoodsCategory(json: json)
    }
}

/// Since GoodsCategoryController doesn't require anything to
/// be initialized we can conform it to EmptyInitializable.
///
/// This will allow it to be passed by type.
extension GoodsCategoryController: EmptyInitializable { }


