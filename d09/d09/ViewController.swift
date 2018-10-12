//
//  ViewController.swift
//  d09
//
//  Created by Jimmy CHEN-MA on 10/12/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit
import jichen_m2018

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let articles = ArticleManager()
    var art:[Article] = []
    
    @IBOutlet weak var tableViewArticle: UITableView!
    
    @IBAction func addArticle(_ sender: UIBarButtonItem)
    {
        performSegue(withIdentifier: "addArticleSegue", sender: "")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return art.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticleTableViewCell
        
        cell.displayArticle(article: art[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "addArticleSegue")
        {
            if let vc = segue.destination as? AddArticleViewController
            {
                vc.articles = articles
            }
        }
    }
    
    @IBAction func addArticleUnwindSegue(segue: UIStoryboardSegue)
    {
        art = articles.getAllArticles()
        tableViewArticle.reloadData()
        tableViewArticle.endUpdates()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       navigationItem.hidesBackButton = true
      
        art = articles.getAllArticles()
        
//        let _ = articles.newArticle(title: "test", content: "content of Test", language: "fr", image: nil)
//        articles.save()
//        let a = articles.getAllArticles()
//        print (art)
        
//        articles.removeAllArticles()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

