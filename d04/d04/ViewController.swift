//
//  ViewController.swift
//  d04
//
//  Created by Jimmy CHEN-MA on 10/4/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APITwitterDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    @IBOutlet weak var TweetTableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    var TweetsArray : [Tweet] = []
    var stringToSearch:String = "ecole 42"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count", TweetsArray.count)
        return TweetsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
//        cell.tweetcell = TweetsArray[indexPath.row]
        cell.displayCell(tweet: TweetsArray[indexPath.row])
        print (TweetsArray[indexPath.row])
        return cell
    }
    
    func TreatTweet(TweetArray: [Tweet])
    {
        TweetsArray = TweetArray
        DispatchQueue.main.async
        {
            self.TweetTableView.reloadData()
            self.TweetTableView.endUpdates()
        }
       
        print (TweetsArray)
    }
    
    func TweetError(tweetError: NSError)
    {
        let alert = UIAlertController(title: "Error", message: "Connect to TwitterAPI.", preferredStyle:UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
//        print(searchText)
        stringToSearch = searchText
    }
    
    func searchBarSearchButtonClicked(_: UISearchBar)
    {
//        print ("enter button was pressed")
        if (stringToSearch != "")
        {
           viewDidLoad()
        }
    }

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let Customer_key = "bNrW9SPnwLvijAeQQYdwroyzB"
        let Customer_secret = "XxU7Z2RNIJyQjiQYWHxQGQT4bth3QBXoKfI1kuqEzCOThwczrl"
        let KeyString = String(Customer_key + ":" + Customer_secret)
        let Bearer = (KeyString.data(using: String.Encoding.utf8))?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        let url = NSURL(string: "https://api.twitter.com/oauth2/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + Bearer!, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = ("grant_type=client_credentials").data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            data, response, error in
            if let err = error {
                self.TweetError(tweetError: err as NSError)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
//                        print (dic)
//                        print (dic["access_token"]!)
                        let res = APIController(token: dic["access_token"] as! String, delegate: self)
                        res.searchString(strToSearch: self.stringToSearch)
                    }
                }
                catch (let err) {
                    self.TweetError(tweetError: err as NSError)
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

