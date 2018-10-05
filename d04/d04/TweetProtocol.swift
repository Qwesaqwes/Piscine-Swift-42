//
//  TweetProtocol.swift
//  d04
//
//  Created by Jimmy CHEN-MA on 10/5/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import Foundation

protocol APITwitterDelegate : NSObjectProtocol
{
    func TreatTweet(TweetArray:[Tweet])
    func TweetError(tweetError:NSError)
}

