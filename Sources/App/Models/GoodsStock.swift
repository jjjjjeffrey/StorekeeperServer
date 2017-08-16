//
//  GoodsStock.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/8/7.
//
//

import Vapor
import FluentProvider
import HTTP

final class GoodsStock: Model {
    let storage = Storage()
    
    var userId: Identifier
    var goodsId: Identifier
    var count: Int
    var price: Double
    var goodsName: String
    
    static let idKey = "id"
    static let userIdKey = "userId"
    static let goodsIdKey = "goodsId"
    static let countKey = "count"
    static let priceKey = "price"
    static let goodsNameKey = "goodsName"
    
    
    init(userId: Identifier,
         goodsId: Identifier,
         count: Int,
         price: Double,
         goodsName: String) {
        self.userId = userId
        self.goodsId = goodsId
        self.count = count
        self.price = price
        self.goodsName = goodsName
    }
    
    init(row: Row) throws {
        userId = try row.get(GoodsStock.userIdKey)
        goodsId = try row.get(GoodsStock.goodsIdKey)
        count = try row.get(GoodsStock.countKey)
        price = try row.get(GoodsStock.priceKey)
        goodsName = try row.get(GoodsStock.goodsNameKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(GoodsStock.userIdKey, userId)
        try row.set(GoodsStock.goodsIdKey, goodsId)
        try row.set(GoodsStock.countKey, count)
        try row.set(GoodsStock.priceKey, price)
        try row.set(GoodsStock.goodsNameKey, goodsName)
        return row
    }
}

// MARK: Fluent Preparation

extension GoodsStock: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.int(GoodsStock.countKey)
            builder.double(GoodsStock.priceKey)
            builder.string(GoodsStock.goodsNameKey)
            builder.parent(User.self)
            builder.parent(Goods.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension GoodsStock: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            userId: Identifier(-1),
            goodsId: json.get(GoodsStock.goodsIdKey),
            count: json.get(GoodsStock.countKey),
            price: json.get(GoodsStock.priceKey),
            goodsName: json.get(GoodsStock.goodsNameKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(GoodsStock.idKey, id)
        try json.set(GoodsStock.goodsIdKey, goodsId)
        try json.set(GoodsStock.countKey, count)
        try json.set(GoodsStock.priceKey, price)
        try json.set(GoodsStock.goodsNameKey, goodsName)
        return json
    }
}

extension GoodsStock: ResponseRepresentable { }
extension GoodsStock: Timestampable { }

extension GoodsStock: Updateable {
    
    public static var updateableKeys: [UpdateableKey<GoodsStock>] {
        return [
            UpdateableKey(GoodsStock.countKey, Int.self) { stock, count in
                stock.count = count
            }
        ]
    }
}
