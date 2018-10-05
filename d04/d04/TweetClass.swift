//
//  TweetClass.swift
//  d04
//
//  Created by Jimmy CHEN-MA on 10/4/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import Foundation

struct Tweet: CustomStringConvertible
{
    /* Person who tweet */
    let name:String
    /* Tweet text */
    let text:String
    
    let date:Date
    
    var description: String
    {
        return "\(name)\n\(text)\n\(date)"
    }
}
