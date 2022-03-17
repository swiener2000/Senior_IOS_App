//
//  HealthViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 3/14/22.
//

import UIKit
import Parse
class HealthViewController: UIViewController{
    

    var BAC: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        BAC = getBAC()
        
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
