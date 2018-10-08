//
//  PostTopic.swift
//  rush00
//
//  Created by Quentin ROULON on 10/7/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import Foundation

struct PostTopic: Codable {
    init(name: String, author_id: String, kind: String, content: String) {
        topic = TopicTopic(
            name: name,
            author_id: author_id,
            kind: kind,
            messages_attributes: [TopicMessage(
                content: content
                )
            ]
        )
    }
    
    struct TopicMessage: Codable {
        let content: String
    }
    
    struct TopicTopic: Codable {
        // tags : Piscine iOS Swift / Piscine Swift iOS
        let tag_ids: [String] = ["574", "578"]
        let name: String
        let author_id: String
        let kind: String
        // language Français
        let language_id: String = "1"
        let messages_attributes: [TopicMessage]
        // cursus 42
        let cursus_ids: [String] = ["1"]
    }
    
    let topic: TopicTopic
}
