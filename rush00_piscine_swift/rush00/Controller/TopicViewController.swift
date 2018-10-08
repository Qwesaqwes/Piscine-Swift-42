//
//  TopicViewController.swift
//  rush00
//
//  Created by Quentin ROULON on 10/6/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController, API42Delegate, UITableViewDelegate, UITableViewDataSource {
  
    /*************
     * VARIABLES
     **************/
    
    var token: String = ""
    var author: Author  = Author(id: 0, login: "")
    
    var schoolApiController: APIController?
    var topics: [Topic] = []
    @IBOutlet weak var topicTableView: UITableView! {
        didSet {
            self.topicTableView.delegate = self
            self.topicTableView.dataSource = self
        }
    }
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBAction func refreshTopicsButton(_ sender: UIBarButtonItem) {
        schoolApiController?.loadTopics()
    }
    @IBAction func unwindSegueToTopicsView(segue: UIStoryboardSegue) {
        schoolApiController?.loadTopics()
    }
    
    /*************
     * PROTOCOLS
     **************/

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell") as? TopicTableViewCell
        let data = self.topics[indexPath.row]
        if self.author.id == data.author.id {
            cell?.topicIsMine(isMine: true)
        } else {
            cell?.topicIsMine(isMine: false)
        }
        cell?.displayTopic(topic: data)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "displayMessageSegue", sender: topics[indexPath.row])
    }
    
    func displayLogin(request: String) { }
    
    func processApiResult(results: [Any]) {
        if let topicsTmp = results as? [Topic] {
            topics = topicsTmp
            DispatchQueue.main.async {
                self.topicTableView.reloadData()
                self.topicTableView.endUpdates()
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

        print("token :", token)
        navigationBar.hidesBackButton = true
        self.schoolApiController = APIController(delegate: self, token: token)
        schoolApiController?.loadTopics()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayMessageSegue" {
            if let topic = sender as? Topic {
                if let messageViewController = segue.destination as? MessageViewController {
                    messageViewController.titleViewControllerTmp = topic.name
                    messageViewController.token = self.token
                    messageViewController.topicId = topic.id
                    messageViewController.topicName = topic.name
                    messageViewController.topicDetail = topic.message.content.markdown
                    messageViewController.author = self.author
                    if topic.author.id == self.author.id {
                        messageViewController.isMine = true
                    } else {
                        messageViewController.isMine = false
                    }
                }
            }
        } else if segue.identifier == "addTopicSegue" {
            if let addTopicViewController = segue.destination as? AddTopicViewController {
                addTopicViewController.token = self.token
                addTopicViewController.author = self.author
                addTopicViewController.isUpdate = false
            }
        }
    }
}
