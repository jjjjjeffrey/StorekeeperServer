//
//  GoodsUnit.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/8/2.
//
//

import Vapor
import FluentProvider
import HTTP

final class GoodsUnit: Model {
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
        userId = try row.get(GoodsUnit.userIdKey)
        name = try row.get(GoodsUnit.nameKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(GoodsUnit.userIdKey, userId)
        try row.set(GoodsUnit.nameKey, name)
        return row
    }
}

// MARK: Fluent Preparation

extension GoodsUnit: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(GoodsUnit.nameKey)
            builder.parent(User.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension GoodsUnit: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get(GoodsUnit.nameKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(GoodsUnit.idKey, id)
        try json.set(GoodsUnit.nameKey, name)
        return json
    }
}

extension GoodsUnit: ResponseRepresentable { }


extension GoodsUnit: Updateable {
    
    public static var updateableKeys: [UpdateableKey<GoodsUnit>] {
        return [
            UpdateableKey(GoodsUnit.nameKey, String.self) { unit, name in
                unit.name = name
            }
        ]
    }
}
