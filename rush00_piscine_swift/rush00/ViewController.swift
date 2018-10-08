//
//  ViewController.swift
//  rush00
//
//  Created by Quentin ROULON on 10/5/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, API42Delegate, SFSafariViewControllerDelegate {
    
    /*************
     * VARIABLES
     **************/

    var token: String = ""
    var author: Author  = Author(id: 0, login: "")
    
    var schoolApiController: APIController?
    var safariViewController: SFSafariViewController?
    
    /*************
     * ACTIONS
     **************/
    
    @IBAction func loginTo42Button(_ sender: UIButton) {
        schoolApiController?.loadAuthorization()
    }
    
    @IBAction func unwindSegueToRootView(segue: UIStoryboardSegue) {
        
    }
    
    /*************
     * PROTOCOLS
     **************/
    
    func displayLogin(request: String) {
        let url = URL(string: request)
        safariViewController = SFSafariViewController(url: url!)
        present(safariViewController!, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        safariViewController?.dismiss(animated: true, completion: nil)
    }
    
    func sendTokenToSegue(token: String) {
        if (token != "") {
            self.performSegue(withIdentifier: "displayTopicSegue", sender: token)
        }
        safariViewControllerDidFinish(safariViewController!)
    }
    
    func processApiResult(results: [Any]) { }
    
    func apiError(error: Error, message: String =  "An error occured") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    /*************
     * OVERRIDE
     *************/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayTopicSegue" {
            if let token = sender as? String, token != "" {
                if let viewController = segue.destination as? TopicViewController {
                    viewController.token = token
                    viewController.author = self.author
                }
            }
        } else if segue.identifier == "cheatLoginSegue" {
            if let viewController = segue.destination as? TopicViewController {
                viewController.token = "bc596c6f15c3bbcd5f9c8a33662942cedaec057270aa7cc0c5ee0c6649076cc9"
                viewController.author = Author(id: 16676, login: "quroulon")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.viewController = self
        self.schoolApiController = APIController(delegate: self, token: token)
    }
}

