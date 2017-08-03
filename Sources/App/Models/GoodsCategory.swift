//
//  GoodsCategory.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/7/28.
//
//

import Vapor
import FluentProvider
import HTTP

final class GoodsCategory: Model {
    let storage = Storage()
    
    var userId: Identifier?
    var name: String
    
    static let idKey = "id"
    static let userIdKey = "userId"
    static let nameKey = "name"
    
    init(name: String) {
        self.name = name
    }
    
    init(row: Row) throws {
        userId = try row.get(GoodsCategory.userIdKey)
        name = try row.get(GoodsCategory.nameKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(GoodsCategory.userIdKey, userId)
        try row.set(GoodsCategory.nameKey, name)
        return row
    }
}

// MARK: Fluent Preparation

extension GoodsCategory: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(GoodsCategory.nameKey)
            builder.parent(User.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension GoodsCategory: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get(GoodsCategory.nameKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(GoodsCategory.idKey, id)
        try json.set(GoodsCategory.nameKey, name)
        return json
    }
}

extension GoodsCategory: ResponseRepresentable { }


extension GoodsCategory: Updateable {
    
    public static var updateableKeys: [UpdateableKey<GoodsCategory>] {
        return [
            UpdateableKey(GoodsCategory.nameKey, String.self) { category, name in
                category.name = name
            }
        ]
    }
}

