//
//  App.swift
//  StorekeeperServer
//
//  Created by zengdaqian on 2017/7/24.
//
//

import MySQLProvider

public struct App {
    public static let share = App()
    private(set) var drop: Droplet
    
    private init() {
        do {
            let config = try Config()
            try config.addProvider(MySQLProvider.Provider.self)
            try config.setup()
            
            drop = try Droplet(config)
            try drop.setup()
        } catch {
            fatalError()
        }
        
    }
    
    public mutating func run() throws {
        try drop.run()
    }
    
}
