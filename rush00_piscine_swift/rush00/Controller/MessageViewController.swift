//
//  MessageViewController.swift
//  rush00
//
//  Created by Quentin ROULON on 10/6/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, API42Delegate, UITableViewDelegate, UITableViewDataSource {

    /*************
     * VARIABLES
     **************/
    
    var token: String = ""
    var author: Author  = Author(id: 0, login: "")
    
    var schoolApiController: APIController?
    var titleViewControllerTmp: String = ""
    var messages: [Message] = []
    var topicId: Int = 0
    var topicName:String = ""
    var topicDetail:String = ""
//    var kindtitle:String = ""
    var isMine: Bool = false
    
    @IBOutlet weak var deleteTopicOutlet: UIButton!
    @IBOutlet weak var updateTopicOutlet: UIButton!
    @IBOutlet weak var titleViewController: UINavigationItem!
    @IBOutlet weak var messageTableView: UITableView! {
        didSet {
            self.messageTableView.delegate = self
            self.messageTableView.dataSource = self
        }
    }
    
    /*************
     * ACTIONS
     **************/
    
    @IBAction func unwindSegueToTopicView(segue: UIStoryboardSegue) {
        self.schoolApiController?.loadMessages(topicId: self.topicId)
    }
    
    @IBAction func deleteTopicButton(_ sender: UIButton) {
        if self.author.id != 0 && self.topicId != 0 {
            self.schoolApiController?.deleteTopic(topicId: self.topicId)
//            performSegue(withIdentifier: "unwindSegueToTopicsView", sender: "")
        }
    }
    
    @IBAction func updateTopicButton(_ sender: UIButton) {
        
    }
    
    @IBAction func refreshMessagesButton(_ sender: UIBarButtonItem) {
        schoolApiController?.loadMessages(topicId: topicId)
    }
    
    /*************
     * PROTOCOLS
     **************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? MessageTableViewCell
        let data = self.messages[indexPath.row]
        if self.author.id == data.author.id {
            cell?.messageIsMine(isMine: true)
        } else {
            cell?.messageIsMine(isMine: false)
        }
        cell?.displayMessage(message: data)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "displayReplySegue", sender: messages[indexPath.row])
    }
    
    func displayLogin(request: String) { }
    
    func processApiResult(results: [Any]) {
        if let messagesTmp = results as? [Message] {
            messages = messagesTmp
            DispatchQueue.main.async {
                self.messageTableView.reloadData()
                self.messageTableView.endUpdates()
            }
        }
    }
        
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
     * OVERRIDE
     *************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isMine == true {
            deleteTopicOutlet.isEnabled = true
            updateTopicOutlet.isEnabled = true
        } else {
            deleteTopicOutlet.isEnabled = false
            updateTopicOutlet.isEnabled = false
        }
        
        self.schoolApiController = APIController(delegate: self, token: token)
        self.titleViewController.title = self.titleViewControllerTmp
        schoolApiController?.loadMessages(topicId: self.topicId)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayReplySegue" {
            if let message = sender as? Message {
                if let replyViewController = segue.destination as? ReplyViewController {
                    replyViewController.replies = message.replies
                    replyViewController.currentMessageLabelTmp = message.content
                    replyViewController.token = token
                    replyViewController.author = self.author
                    replyViewController.messageId = message.id
                    if message.author.id == self.author.id {
                        replyViewController.isMine = true
                    } else {
                        replyViewController.isMine = false
                    }                    
                }
            }
        }
        else if (segue.identifier == "addMessageSegue")
        {
            if let addMessageViewController = segue.destination as? AddMessageViewController
            {
                addMessageViewController.token = token
                addMessageViewController.topicId = topicId
                addMessageViewController.author = author
            }
        }
        else if segue.identifier == "updateTopicSegue"
        {
            print ("enter segue update")
            if let updateTopicViewController = segue.destination as? AddTopicViewController
            {
                updateTopicViewController.isUpdate = true
                updateTopicViewController.topicName = topicName
                updateTopicViewController.topicDetail = topicDetail
                updateTopicViewController.token = token
                updateTopicViewController.author = author
                updateTopicViewController.topicId = String(topicId)
//                updateTopicViewController.kindTitle = kindtitle
            }
        }
    }
}
