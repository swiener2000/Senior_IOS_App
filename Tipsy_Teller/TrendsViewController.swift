//
//  TrendsViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 1/29/22.
//

import UIKit
import Parse

class TrendsViewController: UIViewController {

    var dates: [String] = [String]()
    var bacArray: [Double] = [Double]()
    var drinksArray: [Int] = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        dates = getDates()
        let results = getBACData()
        bacArray = results.0
        drinksArray = results.1
        
        // Do any additional setup after loading the view.
    }
    @IBAction func backToHome2(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }

    func getDates() -> [String]{
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        var dateArray = [String]()
        var month2: String = ""
        var day2: String = ""
        for _ in 1 ... 7 {
            let day = cal.component(.day, from: date)
            let month = cal.component(.month, from: date)
            let year = cal.component(.year, from: date)
            if(month<10) {
                month2 = String(format: "%02d", month)
            } else {
                month2 = "\(month)"
            }
            if(day<10) {
                day2 = String(format: "%02d", day)
                print(day2)
                
            } else {
                day2 = "\(day)"
            }
            let dates = "\(month2)/\(day2)/\(year)"
            dateArray.append(dates)
            date = cal.date(byAdding: .day, value: -1, to: date)!
        }
        dateArray.reverse()
        print(dateArray)
        return dateArray
    }

    func getBACData() -> ([Double], [Int]) {
        var BACarray = [Double] ()
        var dateArray = [String] ()
        var drinksArray = [Int] ()
        let username = PFUser.current()?.username
        
        let query = PFQuery(className: "BAC")
        query.whereKey("Username", equalTo: username as Any)
  
            do {
                let results = try query.findObjects()
                let objects = results
                for object in objects {
                    let BAC = object.value(forKey: "BAC") as! Double
                    let date = object.value(forKey: "Date2") as! String
                    let drinks = object.value(forKey: "Drinks") as! Int
                    dateArray.append(date)
                    BACarray.append(BAC)
                    drinksArray.append(drinks)
                }
            } catch {
                print(error)
            }
        var updatedBACarray = [Double] ()
        var updatedDrinksarray = [Int] ()
        for date in dates {
            if dateArray.contains(date) {
                let index = dateArray.lastIndex(of: date)!
                updatedBACarray.append(BACarray[index])
                updatedDrinksarray.append(drinksArray[index])
            } else {
                updatedBACarray.append(0.0)
                updatedDrinksarray.append(0)
            }
        }
        print(BACarray)
        print(dateArray)
        print(updatedBACarray)
        print(updatedDrinksarray)
        return (updatedBACarray, updatedDrinksarray)
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
