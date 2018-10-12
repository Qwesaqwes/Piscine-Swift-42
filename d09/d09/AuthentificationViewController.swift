//
//  AuthentificationViewController.swift
//  d09
//
//  Created by Jimmy CHEN-MA on 10/12/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit
import LocalAuthentication
//import jichen_m2018

class AuthentificationViewController: UIViewController {

//    var article:[Article] = []
    
    func authentification()
    {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "You need to be authentificated", reply:{ (success, error) -> Void in
                if success
                {
                    print ("Touch ID succed")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "authentificationSegue", sender: "")
                    }
                }
                else
                {
                    print ("Failed to authentificate")
                    DispatchQueue.main.async {
                        self.authentification()
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "authentificationSegue"
        {
//            if let vc = segue.destination as? ViewController
//            {
////                vc.art = self.article
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let a = ArticleManager()
//        article = a.getAllArticles()
        authentification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}
