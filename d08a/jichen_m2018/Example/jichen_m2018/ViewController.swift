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

        print("\n-------------------ADD NEW ARTICLE ( TOTO )------------------\n")
        let art = article.newArticle(title:"toto", content:"testdeTOTO", language:"en", image:nil)
        article.save()
        var a = article.getAllArticles()
        print (a)
        
        print("\n-------------------PRINT ARTICLES WITH LANG SELECTED------------------\n")
        let art1 = article.getArticles(withLang: "en")
        print (art1)

        print("\n-------------------PRINT ARTICLES WITH STRING SELECTED------------------\n")
        let art2 = article.getArticles(containString: "deTO")
        print (art2)
        
        print("\n-------------------ERASE NEW ARTICLE ( TOTO )------------------\n")
        article.removeArticle(article: art)
        a = article.getAllArticles()
        article.save()
        print (a)
        
        
//        for b in a
//        {
//            article.removeArticle(article: b)
//        }
//        article.save()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

