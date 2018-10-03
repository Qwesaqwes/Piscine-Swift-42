//
//  SecondViewController.swift
//  d02
//
//  Created by Jimmy CHEN-MA on 10/3/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UIViewController
{
    @IBOutlet weak var DeathDetailText: UITextView!
    @IBOutlet weak var DeathTime: UIDatePicker!
    @IBOutlet weak var PersonToKillName: UITextField!
    
    
    @IBAction func Done(_ sender: UIBarButtonItem)
    {
        if (PersonToKillName.text != "")
        {
            print("Kill: \(String(describing: PersonToKillName.text!))\nHow: \(DeathDetailText.text!)\nTime of death: \(DeathTime.date)")
            Data.PersonDetails.append((String(describing: PersonToKillName.text!), DeathDetailText.text, DeathTime.date))
        }
        else
        {
            print("Nothing to print")
        }
        performSegue(withIdentifier: "backSegue", sender: "Foo")
//        print(Data.PersonDetails)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? ViewController
        {
            vc.TableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DeathDetailText?.layer.borderWidth = 1
        DeathDetailText?.layer.borderColor = UIColor.black.cgColor
        DeathDetailText?.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
