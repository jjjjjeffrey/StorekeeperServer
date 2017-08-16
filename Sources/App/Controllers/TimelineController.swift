//
//  File.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/8/16.
//
//

import Foundation
import Vapor
import HTTP
import SwiftDate

final class TimelineController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        let today = Date().string(format: .custom("yyyy-MM-dd"))
        let data = try req.user().timelines.filter(Timeline.createdAtKey, .greaterThan, today).sort(Timeline.createdAtKey, .descending).all().makeJSON()
        return AppResponse(data: data)
    }
    
    func makeResource() -> Resource<Timeline> {
        return Resource(
            index: index
        )
    }
}

extension Request {
    
    func timeline() throws -> Timeline {
        guard let json = json else { throw Abort.badRequest }
        return try Timeline(json: json)
    }
    
}

extension TimelineController: EmptyInitializable { }






