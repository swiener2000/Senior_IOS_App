//
//  TrendsViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 1/29/22.
//

import UIKit
import Parse
import Charts

class TrendsViewController: UIViewController, ChartViewDelegate {

    var dates: [String] = [String]()
    var datesD: [Double] = [Double]()
    var bacArray: [Double] = [Double]()
    var drinksArray: [Int] = [Int]()
    
    var lineChart = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let results2 = getDates()
        dates = results2.0
        datesD = results2.1
        let results = getBACData()
        bacArray = results.0
        drinksArray = results.1
        
        // Do any additional setup after loading the view.
        
        lineChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lineChart.frame = CGRect (x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        lineChart.center = view.center
        
        view.addSubview(lineChart)
        var entries = [ChartDataEntry]()
        print(datesD)
        print(bacArray)
        for x in 0..<(dates.count - 1) {
            print(datesD[x])
            print(bacArray[x])
            entries.append(ChartDataEntry(x: datesD[x], y: bacArray[x]))
        }
        //print(entries)
        let set = LineChartDataSet(entries: entries)
        //print(set)
        //set.colors = ChartColorTemplates.material()
        let data = LineChartData(dataSet: set)
        lineChart.data = data
    }
    
    @IBAction func backToHome2(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }

    func getDates() -> ([String], [Double]){
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        var dateArray = [String]()
        var month2: String = ""
        var day2: String = ""
        var dateArray2 = [Double]()
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
            let dates2 = "\(month2)\(day2)\(year)"
            let dates = "\(month2)/\(day2)/\(year)"
            let dates2D = Double(dates2)!
            dateArray.append(dates)
            dateArray2.append(dates2D)
            date = cal.date(byAdding: .day, value: -1, to: date)!
        }
        dateArray.reverse()
        dateArray2.reverse()
        print("dateArray: \(dateArray)")
        print("dateArray: \(dateArray)")
        return (dateArray, dateArray2)
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
        //print("BACarray: \(BACarray)")
        //print(dateArray)
        //print(updatedBACarray)
        //print(updatedDrinksarray)
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
