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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            articles.removeArticle(article: art[indexPath.row])
            articles.save()
            art = articles.getArticles(withLang: Locale.current.languageCode!)
            tableViewArticle.reloadData()
            tableViewArticle.endUpdates()
        }
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
        
        if segue.identifier == "editArticleSegue"
        {
            if let vc = segue.destination as? AddArticleViewController
            {
                if let artCell = sender as? ArticleTableViewCell
                {
                    vc.art = artCell.art
                    vc.articles = articles
                    vc.edit = true
                }
            }
        }
    }
    
    @IBAction func addArticleUnwindSegue(segue: UIStoryboardSegue)
    {
        art = articles.getArticles(withLang: Locale.current.languageCode!)
        tableViewArticle.reloadData()
        tableViewArticle.endUpdates()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.hidesBackButton = true
        art = articles.getArticles(withLang: Locale.current.languageCode!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

