//
//  Topic.swift
//  rush00
//
//  Created by Quentin ROULON on 10/6/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import Foundation

struct Topic: Codable {
    let id: Int
    let name: String
    let author: Author
    let created_at: String
    let message: TopicMessage
    
    struct TopicMessage: Codable {
        let content: TopicMessageContent
    }
    
    struct TopicMessageContent: Codable {
        let markdown: String
    }
}

