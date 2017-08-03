//
//  Goods.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/8/2.
//
//

import Vapor
import FluentProvider
import HTTP

final class Goods: Model {
    let storage = Storage()
    
    var userId: Identifier?
    var name: String
    var barCode: String?
    var category: String
    var unit: String
    var stock: Int
    var sellPrice: Double
    
    static let idKey = "id"
    static let userIdKey = "userId"
    static let nameKey = "name"
    static let barCodeKey = "barCode"
    static let categoryKey = "category"
    static let unitKey = "unit"
    static let stockKey = "stock"
    static let sellPriceKey = "sellPrice"
    
    init(name: String,
         category: String,
         unit: String,
         sellPrice: Double,
         stock: Int,
         barCode: String? = nil) {
        self.name = name
        self.category = category
        self.unit = unit
        self.barCode = barCode
        self.stock = stock
        self.sellPrice = sellPrice
    }
    
    init(row: Row) throws {
        userId = try row.get(Goods.userIdKey)
        name = try row.get(Goods.nameKey)
        barCode = try row.get(Goods.barCodeKey)
        category = try row.get(Goods.categoryKey)
        unit = try row.get(Goods.unitKey)
        stock = try row.get(Goods.stockKey)
        sellPrice = try row.get(Goods.sellPriceKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Goods.userIdKey, userId)
        try row.set(Goods.nameKey, name)
        try row.set(Goods.barCodeKey, barCode)
        try row.set(Goods.categoryKey, category)
        try row.set(Goods.unitKey, unit)
        try row.set(Goods.stockKey, stock)
        try row.set(Goods.sellPriceKey, sellPrice)
        return row
    }
}

// MARK: Fluent Preparation

extension Goods: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Goods.nameKey)
            builder.string(Goods.barCodeKey, optional: true, unique: true)
            builder.string(Goods.categoryKey)
            builder.string(Goods.unitKey)
            builder.int(Goods.stockKey)
            builder.double(Goods.sellPriceKey)
            builder.parent(User.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Goods: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get(Goods.nameKey),
            category: json.get(Goods.categoryKey),
            unit: json.get(Goods.unitKey),
            sellPrice: json.get(Goods.sellPriceKey),
            stock: json.get(Goods.stockKey),
            barCode: json.get(Goods.barCodeKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Goods.idKey, id)
        try json.set(Goods.nameKey, name)
        try json.set(Goods.barCodeKey, barCode)
        try json.set(Goods.categoryKey, category)
        try json.set(Goods.unitKey, unit)
        try json.set(Goods.stockKey, stock)
        try json.set(Goods.sellPriceKey, sellPrice)
        return json
    }
}

extension Goods: ResponseRepresentable { }


extension Goods: Updateable {
    
    public static var updateableKeys: [UpdateableKey<Goods>] {
        return [
            UpdateableKey(Goods.nameKey, String.self) { goods, name in
                goods.name = name
            }
        ]
    }
}
