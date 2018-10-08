//
//  ReplyViewController.swift
//  rush00
//
//  Created by Quentin ROULON on 10/6/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, API42Delegate, UITableViewDelegate, UITableViewDataSource {

    /*************
     * VARIABLES
     **************/
    
    var token: String = ""
    var author: Author  = Author(id: 0, login: "")
    
    var schoolApiController: APIController?
    var replies: [Message] = []
    var currentMessageLabelTmp: String = ""
    var isMine: Bool = false
    var messageId: Int = 0
    
    @IBOutlet weak var currentMessageLabel: UILabel!
    @IBOutlet weak var replyTableView: UITableView! {
        didSet {
            self.replyTableView.delegate = self
            self.replyTableView.dataSource = self
        }
    }
    @IBOutlet weak var deleteMessageOutlet: UIButton!
    @IBOutlet weak var updateMessageOutlet: UIButton!
    
    /*************
     * ACTIONS
     **************/
    
    @IBAction func deleteMessageButton(_ sender: UIButton) {
        self.schoolApiController?.deleteMessage(messageId: self.messageId)
        performSegue(withIdentifier: "unwindSegueToTopicsView", sender: self)
    }
    
    @IBAction func updateMessageButton(_ sender: UIButton) {
    }
    
    /*************
     * PROTOCOLS
     **************/

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell") as? ReplyTableViewCell
        cell?.displayReply(reply: self.replies[indexPath.row])
        return cell!
    }
    
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
     * OVERRIDE
     *************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isMine == true {
            deleteMessageOutlet.isEnabled = true
            updateMessageOutlet.isEnabled = true
        } else {
            deleteMessageOutlet.isEnabled = false
            updateMessageOutlet.isEnabled = false
        }
        
        self.schoolApiController = APIController(delegate: self, token: token)
        self.currentMessageLabel.text = currentMessageLabelTmp
    }
}
