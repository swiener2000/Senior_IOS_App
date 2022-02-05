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
    override func viewDidLoad() {
        super.viewDidLoad()
        dates = getDates()
        bacArray = getBACData()
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

    func getBACData() -> [Double]{
        var BACarray = [Double] ()
        var dateArray = [String] ()
        let username = PFUser.current()?.username
        
        let query = PFQuery(className: "BAC")
        query.whereKey("Username", equalTo: username as Any)
  
            do {
                let results = try query.findObjects()
                let objects = results
                for object in objects {
                    let BAC = object.value(forKey: "BAC") as! Double
                    let date = object.value(forKey: "Date2") as! String
                    dateArray.append(date)
                    BACarray.append(BAC)
                }
            } catch {
                print(error)
            }
        var updatedBACarray = [Double] ()
        for date in dates {
            if dateArray.contains(date) {
                let index = dateArray.lastIndex(of: date)!
                updatedBACarray.append(BACarray[index])
                
            } else {
                updatedBACarray.append(0.0)
            }
        }
        print(BACarray)
        print(dateArray)
        print(updatedBACarray)
        return updatedBACarray
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
