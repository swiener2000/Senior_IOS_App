//
//  HealthViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 3/14/22.
//

import UIKit
import Parse
class HealthViewController: UIViewController{
    

    
    @IBOutlet weak var one: UITextView!
    @IBOutlet weak var two: UITextView!
    @IBOutlet weak var three: UITextView!
    @IBOutlet weak var four: UITextView!
    @IBOutlet weak var five: UITextView!
    @IBOutlet weak var six: UITextView!
    @IBOutlet weak var seven: UITextView!
    @IBOutlet weak var eight: UITextView!
    @IBOutlet weak var nine: UITextView!
    
    @IBOutlet weak var oneE: UITextView!
    @IBOutlet weak var twoE: UITextView!
    @IBOutlet weak var threeE: UITextView!
    @IBOutlet weak var fourE: UITextView!
    @IBOutlet weak var fiveE: UITextView!
    @IBOutlet weak var sixE: UITextView!
    @IBOutlet weak var sevenE: UITextView!
    @IBOutlet weak var eightE: UITextView!
    @IBOutlet weak var nineE: UITextView!
    
    
    var BAC: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        // Do any additional setup after loading the view.
        BAC = getBAC()
        highlightEffect()
    }
    
    func getBAC() -> Double {
        var bac: Double
        var BACArray = [Double]()
        let username = PFUser.current()?.username
        
        let query = PFQuery(className: "BAC")
        query.whereKey("Username", equalTo: username as Any)
        
        do {
            let results = try query.findObjects()
            let objects = results
            for object in objects {
                let BACopt = object.value(forKey: "BAC") as! Double
                BACArray.append(BACopt)
            }
        } catch {
            print(error)
        }
        bac = BACArray.last!
        print(bac)
        return bac
    }
    
    func highlightEffect() {
        print("Starting")
        if BAC >= 0.01 && BAC <= 0.039999  {
            print(".02")
            one.backgroundColor = UIColor.systemYellow
            oneE.backgroundColor = UIColor.systemYellow
        } else if BAC >= 0.04 && BAC <= 0.069999 {
            print(".05")
            two.backgroundColor = UIColor.systemYellow
            twoE.backgroundColor = UIColor.systemYellow
        } else if BAC >= 0.07 && BAC <= 0.099999  {
            print(".08")
            three.backgroundColor = UIColor.systemYellow
            threeE.backgroundColor = UIColor.systemYellow
        } else if BAC >= 0.10 && BAC <= 0.129999  {
            print(".11")
            four.backgroundColor = UIColor.systemYellow
            fourE.backgroundColor = UIColor.systemYellow
        } else if BAC >= 0.13 && BAC <= 0.159999  {
            print(".14")
            five.backgroundColor = UIColor.systemYellow
            fiveE.backgroundColor = UIColor.systemYellow
        } else if BAC >= 0.16 && BAC <= 0.209999  {
            print(".18")
            six.backgroundColor = UIColor.systemYellow
            sixE.backgroundColor = UIColor.systemYellow
        } else if BAC >= 0.25 && BAC <= 0.309999  {
            print(".26")
            seven.backgroundColor = UIColor.systemYellow
            sevenE.backgroundColor = UIColor.systemYellow
        } else if BAC >= 0.35 && BAC <= 0.49999  {
            eight.backgroundColor = UIColor.systemYellow
            eightE.backgroundColor = UIColor.systemYellow
        } else if BAC >= 0.49999  {
            nine.backgroundColor = UIColor.systemYellow
            nineE.backgroundColor = UIColor.systemYellow
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
