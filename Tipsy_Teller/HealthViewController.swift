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
        if BAC >= 0.01 && BAC <= 0.03 {
            one.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
            oneE.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
        } else if BAC >= 0.04 && BAC <= 0.06 {
            two.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
            twoE.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
        } else if BAC >= 0.07 && BAC <= 0.09 {
            three.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
            threeE.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
        } else if BAC >= 0.10 && BAC <= 0.12 {
            four.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
            fourE.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
        } else if BAC >= 0.13 && BAC <= 0.15 {
            five.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
            fiveE.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
        } else if BAC >= 0.16 && BAC <= 0.20 {
            six.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
            sixE.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
        } else if BAC >= 0.25 && BAC <= 0.30 {
            seven.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
            sevenE.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
        } else if BAC >= 0.35 && BAC <= 0.40 {
            eight.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
            eightE.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
        } else if BAC >= 0.40 {
            nine.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
            nineE.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
        }
    }
    /*let username = PFUser.current()?.username
    
    let query = PFQuery(className: "BAC")
    query.whereKey("Username", equalTo: username as Any)

        do {
            let results = try query.findObjects()
            let objects = results
            for object in objects {
                let BAC = object.value(forKey: "BAC") as! Double
                
                BACarray.append(BAC)
            }
        } catch {
            print(error)
        }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
