//
//  ViewController.swift
//  d07
//
//  Created by Jimmy CHEN-MA on 10/10/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO

class ViewController: UIViewController {

    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var questionText: UITextField!
    
    var bot : RecastAIClient?
    //put token from your recastAI account
    let tokenRecast = ""
    //put key from your ForecastAPI account
    let keyForecast = ""
    
    @IBAction func makeRequestRecasAI(_ sender: UIButton)
    {
        var activityView:UIActivityIndicatorView = UIActivityIndicatorView()
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.hidesWhenStopped = true
        activityView.center = view.center
        view.addSubview(activityView)
        activityView.startAnimating()
        
        if (questionText.text != "")
        {
            self.bot?.textRequest(questionText.text!,
                successHandler: {(res:Response) -> Void in
                    let location = res.get(entity: "location")
                    if (location != nil)
                    {
                        let client = DarkSkyClient(apiKey: self.keyForecast)
                        client.getForecast(latitude: location!["lat"] as! Double, longitude: location!["lng"] as! Double) { result in
                            switch result {
                            case .success(let forecast, _):
                                if let sum = forecast.currently?.summary
                                {
                                    DispatchQueue.main.async {
                                        activityView.stopAnimating()
                                        self.responseLabel.text = sum
                                    }
                                }
                                else
                                {
                                    DispatchQueue.main.async {
                                        activityView.stopAnimating()
                                        self.responseLabel.text = "Failed to get info from Forecast"
                                    }
                                }
                                break;
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    activityView.stopAnimating()
                                    self.responseLabel.text = error.localizedDescription
                                }
                                break;
                            }
                        }
                    }
                    else{
                         activityView.stopAnimating()
                        self.responseLabel.text = "City not found"
                    }
            },
                failureHandle: {(err:Error)->Void in
                    self.responseLabel.text = "request fail"
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        questionText?.layer.borderWidth = 1
        questionText?.layer.borderColor = UIColor.black.cgColor
        questionText?.layer.cornerRadius = 5.0
        
        self.bot = RecastAIClient(token : tokenRecast, language: "en")
    }
}

