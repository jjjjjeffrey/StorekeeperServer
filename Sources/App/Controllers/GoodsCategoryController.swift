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
        
        let user = try req.user()
        guard let json = try user?.goodsCategories.all().makeJSON() else {
            return AppResponse(code: AppResponseCode.success)
        }
        
        
        return AppResponse(data: json)
    }
    
    /// POST /goodsCategory
    func create(_ req: Request) throws -> ResponseRepresentable {
        let category = try req.goodscategory()
        try category.save()
        return category
    }
    
    /// GET /goodsCategory/13rd88
    func show(_ req: Request, category: GoodsCategory) throws -> ResponseRepresentable {
        return category
    }
    
    /// DELETE /goodsCategory/13rd88
    func delete(_ req: Request, category: GoodsCategory) throws -> ResponseRepresentable {
        try category.delete()
        return Response(status: .ok)
    }
    
    
    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values.
    func update(_ req: Request, category: GoodsCategory) throws -> ResponseRepresentable {
        // See `extension Post: Updateable`
        try category.update(for: req)
        
        // Save an return the updated post.
        try category.save()
        return category
    }
    
    /// When a user calls 'PUT' on a specific resource, we should replace any
    /// values that do not exist in the request with null.
    /// This is equivalent to creating a new GoodsCategory with the same ID.
    func replace(_ req: Request, category: GoodsCategory) throws -> ResponseRepresentable {
        // First attempt to create a new Post from the supplied JSON.
        // If any required fields are missing, this request will be denied.
        let new = try req.goodscategory()
        
        // Update the post with all of the properties from
        // the new post
        category.name = new.name
        try category.save()
        
        // Return the updated post
        return category
    }
    
    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this
    /// implementation
    func makeResource() -> Resource<GoodsCategory> {
        return Resource(
            index: index,
            store: create,
            show: show,
            update: update,
            replace: replace,
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


