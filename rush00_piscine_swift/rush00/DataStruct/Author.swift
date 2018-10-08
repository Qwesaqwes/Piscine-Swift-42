//
//  Author.swift
//  rush00
//
//  Created by Quentin ROULON on 10/6/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import Foundation

struct Author: Codable {
    init(id: Int, login: String) {
        self.id = id
        self.login = login
    }
    
    let id: Int
    let login: String
}
