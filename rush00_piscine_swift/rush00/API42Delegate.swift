//
//  API42Delegate.swift
//  rush00
//
//  Created by Quentin ROULON on 10/6/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import Foundation

protocol API42Delegate: NSObjectProtocol {
    
    var author: Author { get set }
    var token: String { get set }
    
    func displayLogin(request: String)
    func processApiResult(results: [Any])
    func apiError(error: Error, message: String)
    func sendTokenToSegue(token: String)
}
