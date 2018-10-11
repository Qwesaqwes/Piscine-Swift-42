//
//  ViewController.swift
//  jichen_m2018
//
//  Created by Qwesaqwes on 10/11/2018.
//  Copyright (c) 2018 Qwesaqwes. All rights reserved.
//

import UIKit
import jichen_m2018

@available(iOS 10.0, *)
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let article = ArticleManager()
        let art = article.newArticle(title:"titi", content:"testdeTITI", language:"fr", image:nil)
        article.save()
        var a = article.getAllArticles()
        print("\n-------------------ADD NEW ARTICLE ( TITI )------------------\n")
        print (a)
        
        let art1 = article.getArticles(withLang: "fr")
        print("\n-------------------PRINT ARTICLES WITH LANG SELECTED------------------\n")
        print (art1)
        
        article.removeArticle(article: art)
        a = article.getAllArticles()
        article.save()
        print("\n-------------------ERASE NEW ARTICLE ( TITI )------------------\n")
        print (a)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

