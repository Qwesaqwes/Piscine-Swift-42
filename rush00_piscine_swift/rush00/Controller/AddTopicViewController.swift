//
//  AddTopicViewController.swift
//  rush00
//
//  Created by Jimmy CHEN-MA on 10/6/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import UIKit

class AddTopicViewController: UIViewController, API42Delegate {
    
    /*************
     * VARIABLES
     **************/
    
    var token: String = ""
    var author: Author  = Author(id: 0, login: "")
    var isUpdate:Bool = false
    var topicName:String = ""
    var topicDetail:String = ""
    var kindTitle:String = ""
    var topicId:String = ""
    
    var schoolApiController: APIController?
    @IBOutlet var KindCollection: [UIButton]!
    @IBOutlet weak var KindButton: UIButton!
    @IBOutlet weak var TopicDetail: UITextView!
    @IBOutlet weak var topicNameLabel: UITextField!
    
    /*************
     * ACTIONS
     **************/
    
    @IBAction func HandleKindSelection(_ sender: UIButton) {
        for k in KindCollection
        {
            UIView.animate(withDuration: 0.3, animations: {
                k.isHidden = !k.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func KindTapped(_ sender: UIButton) {
        switch sender.tag
        {
        case 1:
            KindButton.setTitle("normal", for: .normal)
            break;
        case 2:
             KindButton.setTitle("survey", for: .normal)
            break;
        default:
             KindButton.setTitle("stack_overflow", for: .normal)
            break;
        }
        for k in KindCollection
        {
            UIView.animate(withDuration: 0.3, animations: {
                k.isHidden = !k.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func addTopicDoneButton(_ sender: UIBarButtonItem) {
        if (!isUpdate)
        {
            if TopicDetail.text != "" && topicNameLabel.text != "" && KindButton.titleLabel?.text != "Kind" {
                let postTopic = PostTopic(
                    name: topicNameLabel.text!,
                    author_id: String(author.id),
                    kind: (KindButton.titleLabel?.text)!,
                    content: TopicDetail.text
                )
                self.schoolApiController?.postTopic(postTopic: postTopic)
                performSegue(withIdentifier: "unwindSegueToTopicsView", sender: "")
            } else {
                let alert = UIAlertController(title: "Error", message: "Topic name, Kind type and topic detail are required", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
        else
        {
            if TopicDetail.text != "" && topicNameLabel.text != "" && KindButton.titleLabel?.text != "Kind"
            {
                let updateTopic = PostTopic(
                    name: topicNameLabel.text!,
                    author_id: String(author.id),
                    kind: (KindButton.titleLabel?.text)!,
                    content: TopicDetail.text
                )
                print(updateTopic)
                self.schoolApiController?.updateTopic(update: updateTopic, topic_id: topicId)
                performSegue(withIdentifier: "unwindSegueToTopicsView", sender: "")
            }
            else
            {
                let alert = UIAlertController(title: "Error", message: "Kind type is required", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        
    }
    
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
     * OVERRIDE
     *************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.schoolApiController = APIController(delegate: self, token: token)
        
        TopicDetail?.layer.borderWidth = 1
        TopicDetail?.layer.borderColor = UIColor.black.cgColor
        TopicDetail?.layer.cornerRadius = 5.0
        
        topicNameLabel.text = topicName
        TopicDetail.text = topicDetail
    }
}
