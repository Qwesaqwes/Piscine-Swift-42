//
//  AddMessageViewController.swift
//  rush00
//
//  Created by Jimmy CHEN-MA on 10/7/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import UIKit

class AddMessageViewController: UIViewController, API42Delegate
{
    /*************
     * VARIABLES
     **************/
    
    var token: String = ""
    var author: Author  = Author(id: 0, login: "")
    
    
    var topicId: Int = 0
    var schoolApiController: APIController?
    @IBOutlet weak var messageDetail: UITextView!
    
    /*************
     * PROTOCOLS
     **************/
    
    func displayLogin(request: String) { }
    
    func processApiResult(results: [Any]) { }
    
    func apiError(error: Error, message: String =  "An error occured") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            //            self.performSegue(withIdentifier: "unwindSegueToRootView", sender: self)
        }
    }
    
    func sendTokenToSegue(token: String) { }
    
    /*************
     * ACTIONS
     **************/
    @IBAction func addMessage(_ sender: UIBarButtonItem)
    {
        if messageDetail.text != ""
        {
            let pMessage = PostMessage (author_id: String(author.id), content: messageDetail.text)
            schoolApiController?.messageToPost(postMessage: pMessage, topic_id: topicId)
            performSegue(withIdentifier: "unwindSegueToTopicView", sender: "")
        } else {
            let alert = UIAlertController(title: "Error", message: "Message detail are required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
    
    
    /*************
     * OVERRIDE
     *************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.schoolApiController = APIController(delegate: self, token: token)
        messageDetail?.layer.borderWidth = 1
        messageDetail?.layer.borderColor = UIColor.black.cgColor
        messageDetail?.layer.cornerRadius = 5.0
    }
 }
