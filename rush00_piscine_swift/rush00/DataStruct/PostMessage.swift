//
//  PostMessage.swift
//  rush00
//
//  Created by Jimmy CHEN-MA on 10/7/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import Foundation

struct PostMessage: Codable {
    init(author_id: String, content: String)
    {
        message = Message(
            content: content,
            author_id: author_id
            )
        
    }

    struct Message: Codable
    {
        let content: String
        let author_id: String
    }

    let message:Message
}
