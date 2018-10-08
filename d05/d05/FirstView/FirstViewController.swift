//
//  FirstViewController.swift
//  d05
//
//  Created by Jimmy CHEN-MA on 10/8/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var cityTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data.citys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as! CityTableViewCell
        cell.city = data.citys[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let secondTab = self.tabBarController?.viewControllers![0] as? SecondViewController
        {
            print (data.citys[indexPath.row])
            secondTab.centerMapToCitySelected(latitude: data.citys[indexPath.row].latitude, longitude: data.citys[indexPath.row].longitude)
            tabBarController?.selectedIndex = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

