//
//  APIController.swift
//  d04
//
//  Created by Jimmy CHEN-MA on 10/5/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import Foundation

class APIController
{
    weak var delegate: APITwitterDelegate?
    let token: String
    var tweets: [Tweet] = []
    
    
    init(token:String, delegate:APITwitterDelegate?)
    {
        self.token = token
        self.delegate = delegate
    }
    
    func searchString(strToSearch: String)
    {
        let str = strToSearch.replacingOccurrences(of: " ", with: "%20")
        let url = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json?q=\(str)&count=100&lang=fr&result_type=recent")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            if let err = error
            {
                print (err)
            }
            else if let d = data {
                do
                {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    {
                        if let status = dic["statuses"] as? [[String:Any]]
                        {
                            var tweet: (name:String, text:String, date:Date) = ("", "", Date())
                            
                            for s in status
                            {
                                let title = s["text"] as! String
                                print("text: \(title)")
                                tweet.text = title
                                let date = s["created_at"] as! String
                                print("date: \(date)")
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss ZZZZZ yyyy"
                                tweet.date = dateFormatter.date(from: date)!
                                if let allUserIndex = s.index(forKey: "user") {
                                    if let userEntity = s[allUserIndex].value as? [String:Any] {
                                        if let userName = userEntity.index(forKey: "name") {
                                            print("user:", userEntity[userName].value, "\n\n")
                                            tweet.name = userEntity[userName].value as! String
                                        }
                                    }
                                }
                                self.tweets.append(Tweet(name: tweet.name, text: tweet.text, date: tweet.date))
                            }
                            self.delegate?.TreatTweet(TweetArray: self.tweets)
                        }
                    }
                }
                catch (let err)
                {
                    print (err)
                }
            }
        }
        task.resume()
       
    }
}



