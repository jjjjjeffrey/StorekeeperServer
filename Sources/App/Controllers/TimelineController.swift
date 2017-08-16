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

final class TimelineController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return AppResponse(data: try req.user().timelines.all().makeJSON())
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






