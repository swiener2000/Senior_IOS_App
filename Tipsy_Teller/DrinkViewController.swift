//
//  DrinkViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 1/22/22.
//

import UIKit
import Parse
import CryptoKit
extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}

class DrinkViewController: UIViewController ,  UIPickerViewDelegate, UIPickerViewDataSource{
    
    

    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var BACLabel: UILabel!


    @IBOutlet weak var selectDrink: UIButton!
    @IBOutlet weak var drinkPicker: UIPickerView!
    var selectedDrink: String = "Margarita"
    var cocktailNames: [String] = [String]()
    
    
    @IBOutlet weak var TimerLabel: UILabel!
    var timer:Timer = Timer()
    var count: Int = 0
    var timerCounting: Bool = false
    
    @IBOutlet weak var drivingIndicator1: UITextField!
    @IBOutlet weak var drivingIndicator2: UITextField!
    
    @IBOutlet weak var wineButton: UIButton?
    @IBOutlet weak var beerButton: UIButton!
    @IBOutlet weak var liquorButton: UIButton!
    @IBOutlet weak var maltButton: UIButton!

    @IBOutlet weak var size1Button: UIButton!
    @IBOutlet weak var size2Button: UIButton!
    @IBOutlet weak var size3Button: UIButton!
    @IBOutlet weak var size4Button: UIButton!
    @IBOutlet weak var favDrinkButton: UIButton!
    var isWine: Bool = false
    var isBeer: Bool = false
    var isMalt: Bool = false
    var isLiquor: Bool = false
    var bac: Double = 0.0
    var r: Double = 0.0
    var drinkCount: Int = 0
    var objectID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        checkIfTimerIsRunning()
        loadProfile()
        cocktailNames = queryDrinks()
        self.drinkPicker.delegate = self
        self.drinkPicker.dataSource = self
        selectDrink.setTitle(selectedDrink, for: .normal)
        //startStopButton.setTitleColor(UIColor.green, for: .normal)
        size1Button.isHidden = true
        size2Button.isHidden = true
        size3Button.isHidden = true
        size4Button.isHidden = true
    }
    
    /*
     Function to bring user to home screen
     */
    @IBAction func backToHome(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
        if drinkCount != 0 {
            updateBAC(username: (PFUser.current()?.username)!, BAC: bac, Date: Date() as NSDate, Drinks: drinkCount, Date2: getDate(), Count: count)
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cocktailNames.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return cocktailNames[row] as String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        print("Selected Drink: \(selectedDrink)" )
        
        print("Your selected row value is \(cocktailNames[row])")
        selectedDrink = cocktailNames[row]
        selectDrink.setTitle(selectedDrink, for: .normal)
        
    }
    @IBAction func selectDrink(_ sender: Any) {
        if drinkCount == 0 {
            timerCounting = true
            //startStopButton.setTitle("STOP", for: .normal)
            //startStopButton.setTitleColor(UIColor.red, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
        var SD = 0.0
        let query = PFQuery(className:"Cocktails")
        query.whereKey("Name", equalTo: selectedDrink as Any)
        do {
            let results = try query.findObjects()
            let objects = results
            for object in objects {
                SD = object.value(forKey: "SD") as! Double
                //print(SD)
            }
        } catch {
            print(error)
        }
        
        let weight = PFUser.current()?["Weight"] as? Double
        
        bac = bacCalc(weight: Int(weight!), r: r, drinks: SD, BAC: bac)
        
        let bacRounded = round(bac * 1000) / 1000.0
        drinkCount += 1
        BACLabel.text = "BAC: \(bacRounded)"
        if drinkCount == 1 {
            sendBAC()
        } else {
            print("Button Clicked")
            updateBAC(username: (PFUser.current()?.username)!, BAC: bac, Date: Date() as NSDate, Drinks: drinkCount, Date2: getDate(), Count: count)
        }
       showAlert()
        drivingIndicatorCheck()
    }
    /*
     Called when the button is hit
     unhides size buttons
     sets boolean for BAC calculation
     */
    @IBAction func wineButton(_ sender: Any) {
        size1Button.isHidden = false
        size2Button.isHidden = false
        size3Button.isHidden = false
        size4Button.isHidden = false
        size1Button.setImage(UIImage(named: "5oz_wine.svg"), for: .normal)
        size2Button.setImage(UIImage(named: "10oz_wine.svg"), for: .normal)
        size3Button.setImage(UIImage(named: "25oz_wine.svg"), for: .normal)
        size4Button.setImage(UIImage(named: "40oz_wine.svg"), for: .normal)
        isWine = true
    }
    /*
     Called when the button is hit
     unhides size buttons
     sets boolean for BAC calculation
     */
    @IBAction func maltButton(_ sender: Any) {
        size1Button.isHidden = false
        size2Button.isHidden = false
        size3Button.isHidden = false
        size4Button.isHidden = false
        size1Button.setImage(UIImage(named: "12oz_malt.svg"), for: .normal)
        size2Button.setImage(UIImage(named: "16oz_malt.svg"), for: .normal)
        size3Button.setImage(UIImage(named: "24oz_malt.svg"), for: .normal)
        size4Button.setImage(UIImage(named: "40oz_malt.svg"), for: .normal)
        isMalt = true
    }
    /*
     Called when the button is hit
     unhides size buttons
     sets boolean for BAC calculation
     */
    @IBAction func liquorButton(_ sender: Any) {
        size1Button.isHidden = false
        size2Button.isHidden = false
        size3Button.isHidden = false
        size4Button.isHidden = false
        size1Button.setImage(UIImage(named: "1.5oz_liquor.svg"), for: .normal)
        size2Button.setImage(UIImage(named: "12oz_liquor.svg"), for: .normal)
        size3Button.setImage(UIImage(named: "25oz_liquor.svg"), for: .normal)
        size4Button.setImage(UIImage(named: "40oz_liquor.svg"), for: .normal)
        isLiquor = true
    }
    /*
     Called when the button is hit
     unhides size buttons
     sets boolean for BAC calculation
     */
    @IBAction func beerButton(_ sender: Any) {
        size1Button.isHidden = false
        size2Button.isHidden = false
        size3Button.isHidden = false
        size4Button.isHidden = false
        size1Button.setImage(UIImage(named: "12oz_beer.svg"), for: .normal)
        size2Button.setImage(UIImage(named: "16oz_beer.svg"), for: .normal)
        size3Button.setImage(UIImage(named: "24Oz_beer.svg"), for: .normal)
        size4Button.setImage(UIImage(named: "40oz_beer.svg"), for: .normal)
        isBeer = true
    }
    /*
     Loads users profile to be used in BAC calculation
     */
    func loadProfile() {
        let firstname = PFUser.current()?["First_Name"] as? String
        let lastname = PFUser.current()?["Last_Name"] as? String
        let gender = PFUser.current()?["Gender"] as? Int
        let favDrink = PFUser.current()?["FavDrink"] as? String
        if firstname != nil, lastname != nil {
            let first = firstname
            let last = lastname
            self.profileLabel.text = "\(first!) \(last!)'s Profile"
        } else {
            print("No user found")
        }
        
        if gender == 0 {
            r = 0.55
        } else {
            r = 0.68
        }
        favDrinkButton.setTitle(favDrink, for: .normal)
    }
    /*
     Called when the button is hit
     */
    @IBAction func favDrinkBac(_ sender: Any) {
        if drinkCount == 0 {
            timerCounting = true
            //startStopButton.setTitle("STOP", for: .normal)
            //startStopButton.setTitleColor(UIColor.red, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
        var SD = 0.0
        let favDrink = PFUser.current()?["FavDrink"] as? String
        let query = PFQuery(className:"Cocktails")
        query.whereKey("Name", equalTo: favDrink as Any)
        do {
            let results = try query.findObjects()
            let objects = results
            for object in objects {
                SD = object.value(forKey: "SD") as! Double
                //print(SD)
            }
        } catch {
            print(error)
        }
        
        let weight = PFUser.current()?["Weight"] as? Double
        
        bac = bacCalc(weight: Int(weight!), r: r, drinks: SD, BAC: bac)
        
        let bacRounded = round(bac * 1000) / 1000.0
        drinkCount += 1
        BACLabel.text = "BAC: \(bacRounded)"
        if drinkCount == 1 {
            sendBAC()
        } else {
            print("Button Clicked")
            updateBAC(username: (PFUser.current()?.username)!, BAC: bac, Date: Date() as NSDate, Drinks: drinkCount, Date2: getDate(), Count: count)
        }
       showAlert()
        drivingIndicatorCheck()
    }
    /*
     Called when the button is hit
     calls BAC calculation function for whichever boolean is true from previous buttons
     */
    @IBAction func size1Bac(_ sender: Any) {
        if drinkCount == 0 {
            timerCounting = true
            //startStopButton.setTitle("STOP", for: .normal)
            //startStopButton.setTitleColor(UIColor.red, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
        let weight = PFUser.current()?["Weight"] as? Double
        if isBeer == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 1.0, BAC: bac)
        } else if isWine == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 1.0, BAC: bac)
        } else if isLiquor == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 1.5, BAC: bac)
        } else if isMalt == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 1.4, BAC: bac)
        }
        let bacRounded = round(bac * 1000) / 1000.0
        drinkCount += 1
        BACLabel.text = "BAC: \(bacRounded)"
        if drinkCount == 1 {
            sendBAC()
        } else {
            print("Button Clicked")
            updateBAC(username: (PFUser.current()?.username)!, BAC: bac, Date: Date() as NSDate, Drinks: drinkCount, Date2: getDate(), Count: count)
        }
        showAlert()
        drivingIndicatorCheck()
        isBeer = false
        isWine = false
        isMalt = false
        isLiquor = false
        size1Button.isHidden = true
        size2Button.isHidden = true
        size3Button.isHidden = true
        size4Button.isHidden = true
    }
    /*
     Called when the button is hit
     calls BAC calculation function for whichever boolean is true from previous buttons
     */
    @IBAction func size2Bac(_ sender: Any) {
        if drinkCount == 0 {
            timerCounting = true
            //startStopButton.setTitle("STOP", for: .normal)
            //startStopButton.setTitleColor(UIColor.red, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
        let weight = PFUser.current()?["Weight"] as? Double
        if isBeer == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 1.3, BAC: bac)
        } else if isWine == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 1.5, BAC: bac)
        } else if isLiquor == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 8.0, BAC: bac)
        } else if isMalt == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 1.9, BAC: bac)
        }
        let bacRounded = round(bac * 1000) / 1000.0
        drinkCount += 1
        BACLabel.text = "BAC: \(bacRounded)"
        if drinkCount == 1 {
            sendBAC()
        } else {
            print("Button Clicked")
            updateBAC(username: (PFUser.current()?.username)!, BAC: bac, Date: Date() as NSDate, Drinks: drinkCount, Date2: getDate(), Count: count)
        }
        showAlert()
        drivingIndicatorCheck()
        isBeer = false
        isWine = false
        isMalt = false
        isLiquor = false
        size1Button.isHidden = true
        size2Button.isHidden = true
        size3Button.isHidden = true
        size4Button.isHidden = true
    }
    /*
     Called when the button is hit
     calls BAC calculation function for whichever boolean is true from previous buttons
     */
    @IBAction func size3Bac(_ sender: Any) {
        if drinkCount == 0 {
            timerCounting = true
            //startStopButton.setTitle("STOP", for: .normal)
            //startStopButton.setTitleColor(UIColor.red, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
        let weight = PFUser.current()?["Weight"] as? Double
        if isBeer == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 2.0, BAC: bac)
        } else if isWine == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 5.0, BAC: bac)
        } else if isLiquor == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 17.0, BAC: bac)
        } else if isMalt == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 2.8, BAC: bac)
        }
        let bacRounded = round(bac * 1000) / 1000.0
        drinkCount += 1
        BACLabel.text = "BAC: \(bacRounded)"
        if drinkCount == 1 {
            sendBAC()
        } else {
            print("Button Clicked")
            updateBAC(username: (PFUser.current()?.username)!, BAC: bac, Date: Date() as NSDate, Drinks: drinkCount, Date2: getDate(), Count: count)
        }
        showAlert()
        drivingIndicatorCheck()
        isBeer = false
        isWine = false
        isMalt = false
        isLiquor = false
        size1Button.isHidden = true
        size2Button.isHidden = true
        size3Button.isHidden = true
        size4Button.isHidden = true
    }
    /*
     Called when the button is hit
     calls BAC calculation function for whichever boolean is true from previous buttons
     */
    @IBAction func size4Bac(_ sender: Any) {
        if drinkCount == 0 {
            timerCounting = true
            //startStopButton.setTitle("STOP", for: .normal)
            //startStopButton.setTitleColor(UIColor.red, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
        let weight = PFUser.current()?["Weight"] as? Double
        if isBeer == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 3.3, BAC: bac)
        } else if isWine == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 8.0, BAC: bac)
        } else if isLiquor == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 27.0, BAC: bac)
        } else if isMalt == true {
            bac = bacCalc(weight: Int(weight!), r: r, drinks: 4.7, BAC: bac)
        }
        let bacRounded = round(bac * 1000) / 1000.0
        drinkCount += 1
        BACLabel.text = "BAC: \(bacRounded)"
        if drinkCount == 1 {
            sendBAC()
        } else {
            print("Button Clicked")
            updateBAC(username: (PFUser.current()?.username)!, BAC: bac, Date: Date() as NSDate, Drinks: drinkCount, Date2: getDate(), Count: count)
        }
        showAlert()
        drivingIndicatorCheck()
        isBeer = false
        isWine = false
        isMalt = false
        isLiquor = false
        size1Button.isHidden = true
        size2Button.isHidden = true
        size3Button.isHidden = true
        size4Button.isHidden = true
    }
    /*
     Calculates Blood Alcohol Concentration
     */
    func bacCalc(weight: Int, r: Double, drinks: Double, BAC: Double) -> Double {
        var bac = BAC
        let grams = 454
        let weightGrams = weight * grams
        let drinksGrams = drinks * 14
        bac += ((drinksGrams/(Double(weightGrams) * r))*100)
        return bac
    }

    /*
     Timer functions
     */
    @objc func timerCounter() -> Void
        {
            count = count + 1
            let time = secondsToHoursMinutesSeconds(seconds: count)
            let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            TimerLabel.text = timeString
            adjustBac()
        }
        
        func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
        {
            return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
        }
        
        func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String
        {
            var timeString = ""
            timeString += String(format: "%02d", hours)
            timeString += " : "
            timeString += String(format: "%02d", minutes)
            timeString += " : "
            timeString += String(format: "%02d", seconds)
            return timeString
        }
    /*
     Shows alert after each drink is enter to prevent fall entries
     */
    func showAlert() {
        let alertController = UIAlertController(title:"Drink Entered",message:nil,preferredStyle:.alert)
        self.present(alertController,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 5, repeats:false, block: {_ in
            self.dismiss(animated: true, completion: nil)
        })})
    }
    /*
     Adjusts BAC every hour
     */
    func adjustBac() {
        if count % 3600 == 0 {
            bac = bac - 0.015
        }
        let bacRounded = round(bac * 1000) / 1000.0
        BACLabel.text = "BAC: \(bacRounded)"
        drivingIndicatorCheck()
    }
    /*
     Sends calculated BAC to database
     */
    func sendBAC() {
        let date = Date()
        let date2 = getDate()
        let username = PFUser.current()?.username
        let parseObject = PFObject(className:"BAC")
        let timer = count
        parseObject["Username"] = username
        parseObject["BAC"] = bac
        parseObject["Date"] = date
        parseObject["Drinks"] = drinkCount
        parseObject["Date2"] = date2
        parseObject["Count"] = timer

        // Saves the new object.
        parseObject.saveInBackground {
          (success: Bool, error: Error?) in
          if (success) {
            // The object has been saved.
              print("Object has been saved")
              self.objectID = parseObject.objectId!
          } else {
            // There was a problem, check error.description
              print("error")
          }
        }
        drivingIndicatorCheck()
    }
    /*
     Updates BAC in database
     */
    func updateBAC(username: String, BAC: Double, Date: NSDate, Drinks: Int, Date2: String, Count: Int) {
        let objectid: String = objectID
        print("Object ID \(objectid)")
        let query = PFQuery(className:"BAC")
        print("\(username) \(BAC) \(Date) \(Drinks) \(Count)")
        do {
            let results = try query.getObjectWithId(objectid)
            //print(results)
            results["Username"] = username
            results["BAC"] = BAC
            results["Date"] = Date
            results["Drinks"] = Drinks
            results["Count"] = Count

            results.saveInBackground()
        } catch {
            print("Error \(error)")
        }
        drivingIndicatorCheck()
    }
    /*
     Gets date
     */
    func getDate() -> String {
        let date = Date()
        print("Date: \(date)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        //print(dateFormatter.string(from: date))
        return dateFormatter.string(from: date)
    }
    /*
     Checks if timer has previously been running for today and yesterday and if it is within 10 hours
     */
    func checkIfTimerIsRunning() {
        let query = PFQuery(className:"BAC")
        let user = PFUser.current()?.username as Any
        query.whereKey("Username", equalTo: user)
        let today = getDate()
        let yesterday = Date().dayBefore
        var DateArray = [String]()
        var CountArray = [Int]()
        var BACArray = [Double]()
        var DrinksArray = [Int]()
        var objectIDArray = [String]()
        var updatedAtArray = [Date]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let yesterdayFormatted = dateFormatter.string(from: yesterday)
        print("\(today) \(yesterdayFormatted)")
        query.whereKey("Date2", containedIn: [today, yesterdayFormatted])
        do {
            let results = try query.findObjects()
            //print(results)
            let objects = results
            for object in objects {
                let DateString = object.value(forKey: "Date2") as! String
                let Count = object.value(forKey: "Count") as! Int
                let BAC = object.value(forKey: "BAC") as! Double
                let Drinks = object.value(forKey: "Drinks") as! Int
                let Objectid = object.value(forKey: "objectId") as! String
                let dateString = object.value(forKey: "updatedAt") as! Date
                updatedAtArray.append(dateString)
                DateArray.append(DateString)
                CountArray.append(Count)
                BACArray.append(BAC)
                DrinksArray.append(Drinks)
                objectIDArray.append(Objectid)
            }
        } catch {
            print(error)
        }
        if(!DateArray.isEmpty && !CountArray.isEmpty) {
            if (DateArray.contains(today)) {
                let index = DateArray.lastIndex(of: today)!
                let TodayCount = CountArray[index]
                let TodayBAC = BACArray[index]
                let TodayDrinks = DrinksArray[index]
                let TodayObjectID = objectIDArray[index]
                let TodayUpdatedAt = updatedAtArray[index]
                let timediff = getDateDiff(start: TodayUpdatedAt, end: Date())
                //print(timediff)
                print("TodayCount \(TodayCount)")
                if TodayCount + timediff <= 36000 {
                    print("TodayCount \(TodayCount)")
                    timerCounting = true
                    //startStopButton.setTitle("STOP", for: .normal)
                    //startStopButton.setTitleColor(UIColor.red, for: .normal)
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
                    count = TodayCount + timediff
                    bac = TodayBAC
                    drinkCount = TodayDrinks
                    objectID = TodayObjectID
                    getHoursPast(timediff: timediff)
                } else {
                    print("TodayCount \(TodayCount)")
                    timerCounting = false
                    timer.invalidate()
                    bac = 0.0
                    drinkCount = 0
                }
            } else {
                let index = DateArray.lastIndex(of: yesterdayFormatted)!
                let YesterdayCount = CountArray[index]
                let YesterdayBAC = BACArray[index]
                let YesterdayDrinks = DrinksArray[index]
                let YesterdayObjectID = objectIDArray[index]
                let YesterdayUpdatedAt = updatedAtArray[index]
                let timediff = getDateDiff(start: YesterdayUpdatedAt, end: Date())
                //print(timediff)
                print("YesterdayCount \(YesterdayCount)")
                if YesterdayCount + timediff <= 36000 {
                    print("YesterdayCount \(YesterdayCount)")
                    timerCounting = true
                    //startStopButton.setTitle("STOP", for: .normal)
                    //startStopButton.setTitleColor(UIColor.red, for: .normal)
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
                    count = YesterdayCount + timediff
                    bac = YesterdayBAC
                    drinkCount = YesterdayDrinks
                    objectID = YesterdayObjectID
                    getHoursPast(timediff: timediff)
                } else {
                    timerCounting = false
                    timer.invalidate()
                    bac = 0.0
                    drinkCount = 0
                }
            }
        }
        
        drivingIndicatorCheck()
        //print(DateArray)
    }
    /*
     Queries database for drinks
     */
    func queryDrinks() -> [String]{
        print("Starting Query")
        var cocktails = [String]()

        let query = PFQuery(className:"Cocktails")
        query.selectKeys(["Name"])
        do {
            let results: [PFObject] = try query.findObjects()
            let objects = results
            for object in objects {
                let someString = object.value(forKey: "Name") as! String
                cocktails.append(someString)
            }
        } catch {
            print(error)
        }
        
        print("Finished Query")
        return cocktails
    }
    /*
     Update BAC based on the amount of time that has passed since the app was open
     */
    func updateBACtimePast(Hours: Double) {
        let updateValue = Hours * 0.015
        var Newbac = 0.0
        print("updateValue \(updateValue)")
        
        if bac != 0.0 {
            Newbac = bac - updateValue
            if (Newbac >= 0.0) {
                print("bac \(bac)")
                bac = Newbac
            } else {
                bac = 0.0
            }
        }
        
        print("updated bac \(bac)")

        let bacRounded = round(bac * 1000) / 1000.0
        BACLabel.text = "BAC: \(bacRounded)"
    }
    /*
     get the number of hours that has passed since the last time on the page
     */
    func getHoursPast(timediff: Int){
        let hours: Int
        hours = timediff / 3600
        print("Hours: \(Double(hours)) ")
        updateBACtimePast(Hours: Double(hours))
    }
    /*
     get the difference in time
     */
    func getDateDiff(start: Date, end: Date) -> Int  {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)

        let seconds = dateComponents.second
        return Int(seconds!)
    }
    /*
     sets a indicator based on BAC 
     */
    func drivingIndicatorCheck() {
        if bac < 0.08 && bac >= 0.01 {
            self.drivingIndicator1.text = "You are safe to drive!"
            self.drivingIndicator2.isHidden = true
        } else if bac > 0.08 && bac < 0.20 {
            self.drivingIndicator1.text = "Be careful, you are legally intoxicated!"
            self.drivingIndicator2.isHidden = false
            self.drivingIndicator2.text = "No Driving allowed!!"
        } else if bac > 0.21 && bac < 0.40 {
            self.drivingIndicator1.text = "You have reached dangerous level!"
            self.drivingIndicator2.isHidden = false
            self.drivingIndicator2.text = "NO DRIVING ALLOWED!!"
        } else if bac == 0.0 {
            self.drivingIndicator1.text = "You are safe to drive!"
            self.drivingIndicator2.isHidden = true
        }else {
            self.drivingIndicator1.text = "STOP DRINKING!!"
            self.drivingIndicator2.isHidden = false
            self.drivingIndicator2.text = "You are way past the safe levels"
        }
        
    }
}
