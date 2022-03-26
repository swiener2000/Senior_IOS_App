//
//  profileUpdateViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 3/26/22.
//

import UIKit
import Parse
class profileUpdateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    

    @IBOutlet weak var FirstNameText: UITextField!
    @IBOutlet weak var LastNameText: UITextField!
    @IBOutlet weak var GenderSlider: UISegmentedControl!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var favDrinkLabel: UILabel!
    @IBOutlet weak var favDrink: UIPickerView!
    
    var favDrink1: String = "Margarita"
    var cocktailNames: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        cocktailNames = queryDrinks()
        self.favDrink.delegate = self
        self.favDrink.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
                
        weightLabel.text = "Weight: \(currentValue) lbs"
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
        favDrinkLabel.text = ("Favorite Drink: \(cocktailNames[row])")
        print("Your selected row value is \(cocktailNames[row])")
        favDrink1 = cocktailNames[row]
    }
    @IBAction func updateProfile(_ sender: Any) {
        var currentUser = PFUser.current()
        if currentUser != nil {
          

            currentUser?.saveInBackground()
        }
    }
    
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
