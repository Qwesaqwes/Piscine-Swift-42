//
//  ViewController.swift
//  d00
//
//  Created by Jimmy CHEN-MA on 10/1/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var number:Int = 0
    var typeOperator:Int = 0
    var savedTypeOperator:Int = 0
    var saveFirstOperant:Int = 0
    var savedOperand:Bool = false
    var selectedOperator:Bool = false
    
    
    @IBOutlet weak var NumberLabel: UILabel!
    
    func checknumber(nb:Int, param:Int) -> Int
    {
        var a:Int = 0
        var tmp:Int = param
        
        if (tmp != 0)
        {
            a = tmp
            let res = a.multipliedReportingOverflow(by:10)
            if (res.1 == true)
            {
                print("did Overflow1")
                return a
            }
            else
            {
                tmp = res.0
                let result = (tmp < 0) ? tmp.subtractingReportingOverflow(nb) : tmp.addingReportingOverflow(nb)
                if (result.1 == false)
                {
                    return result.0
                }
                print("did Overflow2")
                return a
            }
        }
        return nb
    }
    
    @IBAction func Numbers(_ sender: UIButton)
    {
        number = checknumber(nb:Int(sender.tag - 1), param:number)
        selectedOperator = false
        NumberLabel.text = String(number)
    }
   
    func checkIfNeedCalcul() -> Void {
        if (savedOperand == true)
        {
            switch (savedTypeOperator)
            {
                case 1:
                    let result = saveFirstOperant.addingReportingOverflow(number)
                    checkTupleOverflow(result:result.0, isOverflow:result.1, str:"Addition")
                    break
                case 2:
                    let result = saveFirstOperant.subtractingReportingOverflow(number)
                    checkTupleOverflow(result:result.0, isOverflow:result.1, str:"Substraction")
                    break
                case 3:
                    let result = saveFirstOperant.multipliedReportingOverflow(by:number)
                    checkTupleOverflow(result:result.0, isOverflow:result.1, str:"Multiplication")
                    break
                default:
                    let result = saveFirstOperant.dividedReportingOverflow(by:number)
                    checkTupleOverflow(result:result.0, isOverflow:result.1, str:"Divition")
                    break
            }
        }
    }
    
    @IBAction func Operators(_ sender: UIButton)
    {
        if (NumberLabel.text != "" && selectedOperator == false)
        {
            switch (sender.tag)
            {
                case 13:    //+ Operator
                    typeOperator = 1
                    checkIfNeedCalcul()
                    break
                case 14:    //- Operator
                    typeOperator = 2
                    checkIfNeedCalcul()
                    break
                case 15:    //* Operator
                    typeOperator = 3
                    checkIfNeedCalcul()
                    break
                default:    //'/' Operator
                    typeOperator = 4
                    checkIfNeedCalcul()
                    break
            }
            saveFirstOperant = number
            savedOperand = true
            savedTypeOperator = typeOperator
            number = 0
            selectedOperator = true
//            NumberLabel.text = ""
        }
    }
    
    func checkTupleOverflow(result:Int, isOverflow:Bool, str:String)
    {
        if (isOverflow == true)
        {
            NumberLabel.text = str + " Overflow"
            number = 0
        }
        else
        {
            number = result
            NumberLabel.text = String(number)
        }
    }
    
    @IBAction func Result(_ sender: UIButton)
    {
        if (NumberLabel.text != "" && savedOperand == true && selectedOperator == false)
        {
            switch (typeOperator)
            {
                case 1:
                    let result = saveFirstOperant.addingReportingOverflow(number)
                    checkTupleOverflow(result:result.0, isOverflow:result.1, str:"Addition")
                    break
                case 2:
                    let result = saveFirstOperant.subtractingReportingOverflow(number)
                    checkTupleOverflow(result:result.0, isOverflow:result.1, str:"Substraction")
                    break
                case 3:
                    let result = saveFirstOperant.multipliedReportingOverflow(by:number)
                    checkTupleOverflow(result:result.0, isOverflow:result.1, str:"Multiplication")
                    break
                default:
                    let result = saveFirstOperant.dividedReportingOverflow(by:number)
                    checkTupleOverflow(result:result.0, isOverflow:result.1, str:"Divition")
                    break
            }
            savedOperand = false
        }
    }
  
    @IBAction func Reset(_ sender: UIButton)
    {
        if (sender.tag == 11)
        {
            saveFirstOperant = 0
            typeOperator = 0
            savedTypeOperator = 0
            savedOperand = false
            selectedOperator = false
            number = 0
            NumberLabel.text = ""
        }
    }
    
    @IBAction func Negative(_ sender: UIButton)
    {
        if (selectedOperator == false)
        {
            let res = number.multipliedReportingOverflow(by:-1)
            if (res.1 == true)
            {
                NumberLabel.text = "Overflow"
                number = 0
            }
            else
            {
                number = res.0
                NumberLabel.text = String(number)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

