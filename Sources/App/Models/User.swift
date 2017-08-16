//
//  User.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/7/24.
//
//

import Vapor
import FluentProvider
import HTTP

final class User: Model {
    let storage = Storage()

    var mobile: String
    var password: String
    var shopName: String
    
    static let idKey = "id"
    static let mobileKey = "mobile"
    static let shopNameKey = "shopName"
    static let passwordKey = "password"
    
    init(mobile: String, password: String, shopName: String) {
        self.mobile = mobile
        self.password = password
        self.shopName = shopName
    }
    
    init(row: Row) throws {
        mobile = try row.get(User.mobileKey)
        password = try row.get(User.passwordKey)
        shopName = try row.get(User.shopNameKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(User.mobileKey, mobile)
        try row.set(User.passwordKey, password)
        try row.set(User.shopNameKey, shopName)
        return row
    }
}

// MARK: Fluent Preparation

extension User: Preparation {

    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(User.mobileKey)
            builder.string(User.passwordKey)
            builder.string(User.shopNameKey)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension User: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            mobile: json.get(User.mobileKey),
            password: json.get(User.passwordKey),
            shopName: json.get(User.shopNameKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(User.idKey, id)
        try json.set(User.mobileKey, mobile)
        try json.set(User.shopNameKey, shopName)
        return json
    }
}

extension User: ResponseRepresentable { }
extension User: Timestampable { }

extension User: Updateable {

    public static var updateableKeys: [UpdateableKey<User>] {
        return [
            UpdateableKey(User.mobileKey, String.self) { user, mobile in
                user.mobile = mobile
            },
            UpdateableKey(User.shopNameKey, String.self) { user, shopName in
                user.shopName = shopName
            },
            UpdateableKey(User.passwordKey, String.self) { user, password in
                user.password = password
            }
        ]
    }
}


//relations

extension User {
    var goodsCategories: Children<User, GoodsCategory> {
        return children()
    }
    
    var goodsUnits: Children<User, GoodsUnit> {
        return children()
    }
    
    var goods: Children<User, Goods> {
        return children()
    }
    
    var goodsStocks: Children<User, GoodsStock> {
        return children()
    }
    
    var timelines: Children<User, Timeline> {
        return children()
    }
}









