//
//  Message.swift
//  rush00
//
//  Created by Quentin ROULON on 10/6/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import Foundation

struct Message: Codable {
    let id: Int
    let author: Author
    let content: String
    let replies: [Message]
    let created_at: String
}

