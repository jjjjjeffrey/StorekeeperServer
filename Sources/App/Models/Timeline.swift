//
//  Timeline.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/8/11.
//
//

import Vapor
import FluentProvider
import HTTP

final class Timeline: Model {
    let storage = Storage()
    
    var userId: Identifier
    var title: String
    var content: String
    var type: TimelineType
    
    enum TimelineType: Int {
        case none = -1
        case stockIn
        case sale
    }
    
    static let idKey = "id"
    static let userIdKey = "userId"
    static let titleKey = "title"
    static let contentKey = "content"
    static let typeKey = "type"
    
    
    init(userId: Identifier,
         title: String,
         content: String,
         type: TimelineType) {
        self.userId = userId
        self.title = title
        self.content = content
        self.type = type
    }
    
    convenience init(stock: GoodsStock) {
        let userId = stock.userId
        let title = stock.goodsName
        let content = "进货价 \(stock.price)  进货数量 \(stock.count)"
        let type: TimelineType = .stockIn
        self.init(userId: userId, title: title, content: content, type: type)
    }
    
    init(row: Row) throws {
        userId = try row.get(Timeline.userIdKey)
        title = try row.get(Timeline.titleKey)
        content = try row.get(Timeline.contentKey)
        let typeInt: Int = try row.get(Timeline.typeKey)
        type = TimelineType(rawValue: typeInt) ?? .none
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Timeline.userIdKey, userId)
        try row.set(Timeline.titleKey, title)
        try row.set(Timeline.contentKey, content)
        try row.set(Timeline.typeKey, type.rawValue)
        return row
    }
}

// MARK: Fluent Preparation

extension Timeline: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Timeline.titleKey)
            builder.string(Timeline.contentKey)
            builder.int(Timeline.typeKey)
            builder.parent(User.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Timeline: JSONConvertible {
    convenience init(json: JSON) throws {
        let type: TimelineType = try json.get(Timeline.typeKey) ?? .none
        
        try self.init(
            userId: json.get(Timeline.userIdKey),
            title: json.get(Timeline.titleKey),
            content: json.get(Timeline.contentKey),
            type: type
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Timeline.idKey, id)
        try json.set(Timeline.titleKey, title)
        try json.set(Timeline.contentKey, content)
        try json.set(Timeline.typeKey, type.rawValue)
        try json.set(Timeline.createdAtKey, createdAt)
        return json
    }
}

extension Timeline: ResponseRepresentable { }
extension Timeline: Timestampable { }

extension Timeline: Updateable {
    
    public static var updateableKeys: [UpdateableKey<Timeline>] {
        return [
            UpdateableKey(Timeline.titleKey, String.self) { timeline, title in
                timeline.title = title
            }
        ]
    }
}
