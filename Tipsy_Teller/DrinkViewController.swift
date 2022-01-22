//
//  DrinkViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 1/22/22.
//

import UIKit
import Parse

class DrinkViewController: UIViewController {

    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var BACLabel: UILabel!

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    var timer:Timer = Timer()
    var count: Int = 0
    var timerCounting: Bool = false
    
    @IBOutlet weak var wineButton: UIButton!
    @IBOutlet weak var beerButton: UIButton!
    @IBOutlet weak var liquorButton: UIButton!
    @IBOutlet weak var maltButton: UIButton!

    @IBOutlet weak var size1Button: UIButton!
    @IBOutlet weak var size2Button: UIButton!
    @IBOutlet weak var size3Button: UIButton!
    @IBOutlet weak var size4Button: UIButton!
    var isWine: Bool = false
    var isBeer: Bool = false
    var isMalt: Bool = false
    var isLiquor: Bool = false
    var bac: Double = 0.0
    var r: Double = 0.0
    var drinkCount: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(PFUser.current()?.username as Any)
        loadProfile()
        startStopButton.setTitleColor(UIColor.green, for: .normal)
        size1Button.isHidden = true
        size2Button.isHidden = true
        size3Button.isHidden = true
        size4Button.isHidden = true
    }
    
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
    func loadProfile() {
        let firstname = PFUser.current()?["First_Name"] as? String
        let lastname = PFUser.current()?["Last_Name"] as? String
        let gender = PFUser.current()?["Gender"] as? Int
        let weight = PFUser.current()?["Weight"] as? Double
        self.profileLabel.text = "\(firstname!) \(lastname!)'s Profile"
        if gender == 0 {
            self.genderLabel.text = "Gender: Female"
            r = 0.55
        } else {
            self.genderLabel.text = "Gender: Male"
            r = 0.68
        }
        self.weightLabel.text = "Weight: \(String(describing: Int(weight!)))"
    }

    @IBAction func size1Bac(_ sender: Any) {
        if drinkCount == 0 {
            timerCounting = true
            startStopButton.setTitle("STOP", for: .normal)
            startStopButton.setTitleColor(UIColor.red, for: .normal)
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
        isBeer = false
        isWine = false
        isMalt = false
        isLiquor = false
        size1Button.isHidden = true
        size2Button.isHidden = true
        size3Button.isHidden = true
        size4Button.isHidden = true
    }
    
    @IBAction func size2Bac(_ sender: Any) {
        if drinkCount == 0 {
            timerCounting = true
            startStopButton.setTitle("STOP", for: .normal)
            startStopButton.setTitleColor(UIColor.red, for: .normal)
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
        isBeer = false
        isWine = false
        isMalt = false
        isLiquor = false
        size1Button.isHidden = true
        size2Button.isHidden = true
        size3Button.isHidden = true
        size4Button.isHidden = true
    }
    @IBAction func size3Bac(_ sender: Any) {
        if drinkCount == 0 {
            timerCounting = true
            startStopButton.setTitle("STOP", for: .normal)
            startStopButton.setTitleColor(UIColor.red, for: .normal)
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
        isBeer = false
        isWine = false
        isMalt = false
        isLiquor = false
        size1Button.isHidden = true
        size2Button.isHidden = true
        size3Button.isHidden = true
        size4Button.isHidden = true
    }
    @IBAction func size4Bac(_ sender: Any) {
        if drinkCount == 0 {
            timerCounting = true
            startStopButton.setTitle("STOP", for: .normal)
            startStopButton.setTitleColor(UIColor.red, for: .normal)
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
        isBeer = false
        isWine = false
        isMalt = false
        isLiquor = false
        size1Button.isHidden = true
        size2Button.isHidden = true
        size3Button.isHidden = true
        size4Button.isHidden = true
    }
    func bacCalc(weight: Int, r: Double, drinks: Double, BAC: Double) -> Double {
        var bac = BAC
        let grams = 454
        let weightGrams = weight * grams
        let drinksGrams = drinks * 14
        bac += ((drinksGrams/(Double(weightGrams) * r))*100)
        return bac
    }

    @IBAction func resetTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Reset Timer?", message: "Are you sure you would like to reset the Timer?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
                    //do nothing
                }))
                
                alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
                    self.count = 0
                    self.timer.invalidate()
                    self.TimerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
                    self.startStopButton.setTitle("START", for: .normal)
                    self.startStopButton.setTitleColor(UIColor.green, for: .normal)
                }))
                
                self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func startStopTapped(_ sender: Any) {
        if(timerCounting)
                {
                    timerCounting = false
                    timer.invalidate()
                    startStopButton.setTitle("START", for: .normal)
                    startStopButton.setTitleColor(UIColor.green, for: .normal)
                }
                else
                {
                    timerCounting = true
                    startStopButton.setTitle("STOP", for: .normal)
                    startStopButton.setTitleColor(UIColor.red, for: .normal)
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
                }
    }
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
    func adjustBac() {
        if count % 3600 == 0 {
            bac = bac - 0.015
            sendBAC()
        }
        let bacRounded = round(bac * 1000) / 1000.0
        BACLabel.text = "BAC: \(bacRounded)"
    }
    func sendBAC() {
        let date = Date()
        let username = PFUser.current()?.username
        let parseObject = PFObject(className:"BAC")

        parseObject["Username"] = username
        parseObject["BAC"] = bac
        parseObject["Date"] = date
        parseObject["Drinks"] = drinkCount

        // Saves the new object.
        parseObject.saveInBackground {
          (success: Bool, error: Error?) in
          if (success) {
            // The object has been saved.
              print("Object has been saved")
          } else {
            // There was a problem, check error.description
              print("error")
          }
        }
    }
    func getDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        print(dateFormatter.string(from: date))
        return dateFormatter.string(from: date)
    }
}
