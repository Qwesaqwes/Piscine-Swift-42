//
//  APIController.swift
//  rush00
//
//  Created by Quentin ROULON on 10/6/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import UIKit

class APIController {
    
    weak var delegate: API42Delegate?
    var token: String
    let host: String
    let customer_uid: String
    let customer_secret : String
    let redirect_uri: String
    let authorization_route: String
    let token_route: String
    let topics_route: String
    let messages_route: String
    
    init(delegate: API42Delegate?, token: String) {
        self.delegate = delegate
        self.token = token
        self.host = "https://api.intra.42.fr"
        self.customer_uid = "483ce5c84e7f4677dfa2f9f77772f067c48f8571e999cf8b8361222ed28577a5"
        self.customer_secret = "05ab78066a2b19781f5ee6bc4ac3c6c72c1dab6de1bd781e04d8d5bb38db1684"
        self.redirect_uri = "quroulon.rush00%3A%2F%2Fcallback"
        self.authorization_route = "/oauth/authorize"
        self.token_route = "/oauth/token"
        self.topics_route = "/topics"
        self.messages_route = "/messages"
        if token != "" && self.delegate?.author.id == 0 {
            self.getUser()
        }
    }
    
    func loadAuthorization() {
        let str:String = host + authorization_route + "?client_id=" + customer_uid + "&redirect_uri=" + redirect_uri + "&response_type=code&scope=public%20forum"
        delegate!.displayLogin(request: str)
    }
    
    func loadTopics() {
        let url = URL(string: host + "/v2" + topics_route)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if let err = error {
                self.delegate?.apiError(error: err, message: "An error occurred for loading topics 1")
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print("DIC", dic)
                    }
                    let decoder = JSONDecoder()
                    if let topics = try decoder.decode([Topic].self, from: d) as [Topic]? {
                        self.delegate!.processApiResult(results: topics)
                    }
                }
                catch (let err) {
                    print("erreur a ce moment")
                    self.delegate?.apiError(error: err, message: err.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func loadMessages(topicId: Int) {
        let url = URL(string: host + "/v2" + topics_route + "/\(topicId)" + messages_route)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if let err = error {
                self.delegate?.apiError(error: err, message: "An error occurred")
            }
            else if let d = data {
                do {
                    let decoder = JSONDecoder()
                    if let messages = try decoder.decode([Message].self, from: d) as [Message]? {
                        if let delegateTmp = self.delegate {
                            delegateTmp.processApiResult(results: messages)
                        }
                    }
                }
                catch (let err) {
                    self.delegate?.apiError(error: err, message: "An error occurred")
                }
            }
        }
        task.resume()
    }
    
    func postTopic(postTopic: PostTopic) {
        let url = URL(string: host + "/v2" + topics_route)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let jsonData: Data = try? encoder.encode(postTopic) {
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
        }

        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if let err = error {
                print (err)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print("DIC", dic)
                    }
                }
                catch (let err) {
                    print (err)
                }
            }
        }
        task.resume()
    }
   
    func messageToPost(postMessage: PostMessage, topic_id: Int)
    {
        let url = URL(string: host + "/v2" + topics_route + "/" + String(topic_id) + messages_route)
        print (url as Any)
        let request = NSMutableURLRequest(url: url!)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let jsonData: Data = try? encoder.encode(postMessage) {
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if let err = error {
                self.delegate?.apiError(error: err, message: "An error occurred")
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print("DIC", dic)
                    }
                }
                catch (let err) {
                    self.delegate?.apiError(error: err, message: "An error occurred")
                }
            }
        }
        task.resume()
    }
    
    func getUser() {
        let url = URL(string: host + "/v2/me")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if let err = error {
                self.delegate?.apiError(error: err, message: "An error occurred")
            }
            else if let d = data {
                do {
                    let decoder = JSONDecoder()
                    if let user = try decoder.decode(Author.self, from: d) as Author? {
                        self.delegate?.author = user
                        self.delegate?.sendTokenToSegue(token: self.token)
                    }
                }
                catch (let err) {
                    self.delegate?.apiError(error: err, message: "Your token is not valid anymore")
                }
            }
        }
        task.resume()
    }
    
    func getToken(code : String) {
        let url = URL(string: host + token_route + "?grant_type=authorization_code&client_id=" + customer_uid + "&client_secret=" + customer_secret + "&code=" + code + "&redirect_uri=" + redirect_uri)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if let err = error {
                print (err)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let tokenTmp = dic["access_token"] as! String? {
                            self.token = tokenTmp
                        }
                        if self.delegate?.author.id != 0 {
                            self.delegate?.sendTokenToSegue(token: self.token)
                        } else {
                            self.getUser()
                        }
                    }
                }
                catch (let err) {
                    self.delegate?.apiError(error: err, message: "An error occurred")
                }
            }
        }
        task.resume()
    }
    
    func deleteTopic(topicId: Int) {
        let url = URL(string: host + "/v2" + topics_route + "/\(topicId)")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
//            print(response!)
            if let err = error {
                self.delegate?.apiError(error: err, message: err.localizedDescription)
            }
//            else if let d = data {
//                print(d)
//            }
        }
        task.resume()
    }
    
    func deleteMessage(messageId: Int) {
        let url = URL(string: host + "/v2" + messages_route + "/\(messageId)")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if let err = error {
                self.delegate?.apiError(error: err, message: err.localizedDescription)
            }
        }
        task.resume()
    }
    
    func updateTopic(update: PostTopic, topic_id: String)
    {
        let url = URL(string: host + "/v2" + topics_route + "/" + topic_id)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let jsonData: Data = try? encoder.encode(update) {
            print(String(data: jsonData, encoding: .utf8)!)
            request.httpBody = jsonData
        }
        
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if let err = error {
                print (err)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print("DIC", dic)
                    }
                }
                catch (let err) {
                    print (err)
                }
            }
        }
        task.resume()
    }
    
}


