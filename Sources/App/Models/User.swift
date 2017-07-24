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
    
    static let idKey = "id"
    static let mobileKey = "mobile"
    
    init(mobile: String) {
        self.mobile = mobile
    }
    
    init(row: Row) throws {
        mobile = try row.get(User.mobileKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(User.mobileKey, mobile)
        return row
    }
}

// MARK: Fluent Preparation

extension User: Preparation {

    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(User.mobileKey)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension User: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            mobile: json.get(User.mobileKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(User.idKey, id)
        try json.set(User.mobileKey, mobile)
        return json
    }
}

extension User: ResponseRepresentable { }


extension User: Updateable {

    public static var updateableKeys: [UpdateableKey<User>] {
        return [
            UpdateableKey(User.mobileKey, String.self) { user, mobile in
                user.mobile = mobile
            }
        ]
    }
}
