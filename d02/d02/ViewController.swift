//
//  ViewController.swift
//  d02
//
//  Created by Jimmy CHEN-MA on 10/3/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var TableView: UITableView!
//    @IBOutlet weak var DeathDetailText: UITextView!
//    @IBOutlet weak var DeathTime: UIDatePicker!
//    @IBOutlet weak var PersonToKillName: UITextField!
    
   
    @IBAction func unWindSegue(segue: UIStoryboardSegue)
    {
//        print(segue.identifier ?? <#default value#>)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Data.PersonDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell") as! PersonTableViewCell
        cell.death = Data.PersonDetails[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.rowHeight = UITableViewAutomaticDimension
        TableView.estimatedRowHeight = 140
//         Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

