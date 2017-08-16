//
//  GoodsStockController.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/8/7.
//
//

import Foundation
import Vapor
import HTTP

final class GoodsStockController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        
        guard let goodsId = req.data[GoodsStock.goodsIdKey]?.int else {
            return AppResponse(data: try req.user().goodsStocks.all().makeJSON())
        }
        
        return AppResponse(data: try req.user().goodsStocks.filter(GoodsStock.goodsIdKey, .equals, goodsId).all().makeJSON())
        
    }
    
    func create(_ req: Request) throws -> ResponseRepresentable {
        let stock = try req.stock()
        
        guard let goods = try Goods.find(stock.goodsId) else {
            return AppResponse(code: GoodsStockResponseCode.goodsNotExist)
        }
        
        goods.stock += stock.count
        try goods.save()
        
        stock.userId = try req.userId()
        try stock.save()
        
        let timeline = Timeline(stock: stock)
        try timeline.save()
        
        return AppResponse(data: try stock.makeJSON())
    }
    
    func delete(_ req: Request, stock: GoodsStock) throws -> ResponseRepresentable {
        try stock.delete()
        return AppResponse()
    }
    
    func makeResource() -> Resource<GoodsStock> {
        return Resource(
            index: index,
            store: create,
            destroy: delete
        )
    }
}

extension Request {
    
    func stock() throws -> GoodsStock {
        guard let json = json else { throw Abort.badRequest }
        return try GoodsStock(json: json)
    }
    
}

extension GoodsStockController: EmptyInitializable { }



