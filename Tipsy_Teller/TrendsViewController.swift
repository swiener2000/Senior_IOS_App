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
    var avgbacArray: [Double] = [Double]()
    var avgDrinksArray: [Double] = [Double]()
    var lineChart = LineChartView()
    @IBOutlet weak var chtChart1: LineChartView!
    @IBOutlet weak var chtChart2: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let results2 = getDates()
        dates = results2.0
        datesD = results2.1
        let results = getBACData()
        bacArray = results.0
        drinksArray = results.1
        let results3 = getAverages()
        avgbacArray = results3.0
        avgDrinksArray = results3.1
        // Do any additional setup after loading the view.
        
        lineChart.delegate = self
        createGraphs()
    }
    
    
    func createGraphs() {
        print(datesD)
        var entries = [ChartDataEntry]()
        var entries2 = [ChartDataEntry]()
        var entries3 = [ChartDataEntry]()
        var entries4 = [ChartDataEntry]()
        for x in 0..<(dates.count) {
            //print(datesD[x])
            //print(bacArray[x])
            entries.append(ChartDataEntry(x: Double(x), y: bacArray[x]))
            //entries2.append(ChartDataEntry(x: datesD[x], y: avgbacArray[x]))
            entries2.append(ChartDataEntry(x: Double(x), y: avgbacArray[x]))
            entries3.append(ChartDataEntry(x: Double(x), y: Double(drinksArray[x])))
            entries4.append(ChartDataEntry(x: Double(x), y: Double(avgDrinksArray[x])))
            
        }
        print(entries)
        let line1 = LineChartDataSet(entries: entries, label: "Users BAC")
        line1.colors = [NSUIColor.blue]
        let line2 = LineChartDataSet(entries: entries2, label: "Average BAC")
        line2.colors = [NSUIColor.red]
        self.chtChart1.data = LineChartData(dataSets: [line1, line2])

        chtChart1.xAxis.labelPosition = XAxis.LabelPosition.bottom
        let xAxisValue = chtChart1.xAxis
        let dateValue = DateValueFormatter()
        dateValue.dates = dates
        xAxisValue.valueFormatter = dateValue
        
        let line3 = LineChartDataSet(entries: entries3, label: "Users Drink count")
        line3.colors = [NSUIColor.blue]
        let line4 = LineChartDataSet(entries: entries4, label: "Average Drink count")
        line4.colors = [NSUIColor.red]
        self.chtChart2.data = LineChartData(dataSets: [line3, line4])
        
        chtChart2.xAxis.labelPosition = XAxis.LabelPosition.bottom
        let xAxisValue2 = chtChart2.xAxis
        let dateValue2 = DateValueFormatter()
        dateValue2.dates = dates
        xAxisValue2.valueFormatter = dateValue2
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
                //print(day2)
                
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
        //print("dateArray: \(dateArray)")
        //print("dateArray: \(dateArray)")
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
    
    func getAverages() -> ([Double], [Double]){
        var allBACarray = [Double]()
        var allDateArray = [String] ()
        var allDrinksArray = [Int] ()
        let query = PFQuery(className: "BAC")
        do {
            let results = try query.findObjects()
            let objects = results
            for object in objects {
                let BAC = object.value(forKey: "BAC") as! Double
                let date = object.value(forKey: "Date2") as! String
                let drinks = object.value(forKey: "Drinks") as! Int
                allDateArray.append(date)
                allBACarray.append(BAC)
                allDrinksArray.append(drinks)
            }
        } catch {
            print(error)
        }
        var indexes = [Int] ()
        var updatedAllBACArray = [Double] ()
        var updatedAllDRINKSArray = [Double] ()
        var BACIndexes = [Double] ()
        var DRINKSIndexes = [Double] ()
        //print(allDateArray)
        for date in dates {
            if allDateArray.contains(date) {
                let searchValue = date
                var currentIndex = 0
                for dates in allDateArray {
                    if searchValue.elementsEqual(dates) {
                        print("SearchValue: \(searchValue) dates: \(dates)")
                        indexes.append(currentIndex)
                    }
                    currentIndex+=1
                }
                for index in indexes {
                    BACIndexes.append(allBACarray[index])
                    DRINKSIndexes.append(Double(allDrinksArray[index]))
                }
                let BACmean = calculateMean(array: BACIndexes)
                let Drinksmean = calculateMean(array: DRINKSIndexes)
                updatedAllBACArray.append(BACmean)
                updatedAllDRINKSArray.append(Drinksmean)
            } else {
                updatedAllBACArray.append(0.0)
                updatedAllDRINKSArray.append(0.0)
            }
        }
        print("index: \(indexes)")
        print("Updated BAC array: \(updatedAllBACArray)")
        return (updatedAllBACArray, updatedAllDRINKSArray)
    }
    func calculateMean(array: [Double]) -> Double {
        
        // Calculate sum ot items with reduce function
        let sum = array.reduce(0, { a, b in
            return a + b
        })
        
        let mean = Double(sum) / Double(array.count)
        return Double(mean)
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
