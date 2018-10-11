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
        let art = article.newArticle(title:"titi", content:"testdeTITI", language:"en", image:nil)
        article.save()
        var a = article.getAllArticles()
        print (a)
        article.removeArticle(article: art)
//        a = article.getAllArticles()
//        print (a)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

