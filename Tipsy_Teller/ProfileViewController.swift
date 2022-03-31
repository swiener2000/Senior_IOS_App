//
//  ProfileViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 2/21/22.
//

import UIKit
import Parse
class ProfileViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var favDrinkLabel: UILabel!
    
    @IBOutlet weak var saveName: UIButton!
    @IBOutlet weak var updateFirst: UITextField!
    @IBOutlet weak var updateLast: UITextField!
    @IBOutlet weak var updateName: UIButton!
    @IBOutlet weak var updateGender: UIButton!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var saveGender: UIButton!
    @IBOutlet weak var weightLabelUpdate: UILabel!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var saveWeight: UIButton!
    @IBOutlet weak var updateWeight: UIButton!
    @IBOutlet weak var favDrinkPicker: UIPickerView!
    @IBOutlet weak var updateDrink: UIButton!
    @IBOutlet weak var saveDrink: UIButton!
    var r: Double = 0.0
    
    var favDrink: String = "Margarita"
    var cocktailNames: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        cocktailNames = queryDrinks()
        self.favDrinkPicker.delegate = self
        self.favDrinkPicker.dataSource = self
        if let pUserName = PFUser.current()?["username"] as? String {
            self.userNameLabel.text = "@" + pUserName
            let firstname = PFUser.current()?["First_Name"] as? String
            let lastname = PFUser.current()?["Last_Name"] as? String
            let gender = PFUser.current()?["Gender"] as? Int
            let weight = PFUser.current()?["Weight"] as? Double
            let favDrink = PFUser.current()?["FavDrink"] as? String
            if firstname != nil, lastname != nil {
                self.firstNameLabel.text = "\(firstname!)"
                self.lastNameLabel.text = "\(lastname!)"
            } else {
                print("No user found")
            }
            
            if gender == 0 {
                self.genderLabel.text = "Gender: Female"
                r = 0.55
            } else {
                self.genderLabel.text = "Gender: Male"
                r = 0.68
            }
            self.weightLabel.text = "Weight: \(String(describing: Int(weight!)))"
            self.favDrinkLabel.text = "Favorite Drink: \(String(describing: favDrink!))"
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToHome(_ sender: Any) {
        print("Button Clicked")
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
                
        weightLabelUpdate.text = "Weight: \(currentValue) lbs"
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
        favDrink = cocktailNames[row]
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
    
    @IBAction func updateName(_ sender: Any) {
        //hides orginal info
        updateName.isHidden = true
        firstNameLabel.isHidden = true
        lastNameLabel.isHidden = true
        //opens editing
        updateFirst.isHidden = false
        updateLast.isHidden = false
        saveName.isHidden = false
    }
    @IBAction func saveName(_ sender: Any) {
        let newFirst = updateFirst.text
        let newLast = updateLast.text
        firstNameLabel.text = newFirst
        lastNameLabel.text = newLast
        var currentUser = PFUser.current()
        if currentUser != nil {
            currentUser?["First_Name"] = newFirst
            currentUser?["Last_Name"] = newLast

            currentUser?.saveInBackground()
        }
        updateName.isHidden = true
        firstNameLabel.isHidden = false
        lastNameLabel.isHidden = false
        //opens editing
        updateFirst.isHidden = true
        updateLast.isHidden = true
        saveName.isHidden = true
    }
    @IBAction func updateGender(_ sender: Any) {
        updateGender.isHidden = true
        genderLabel.isHidden = true
        
        gender.isHidden = false
        saveGender.isHidden = false
    }
    @IBAction func saveGender(_ sender: Any) {
        var currentUser = PFUser.current()
        if currentUser != nil {
            currentUser?["Gender"] = self.gender.selectedSegmentIndex

            currentUser?.saveInBackground()
        }
        let genderIndex = self.gender.selectedSegmentIndex
        if genderIndex == 0 {
            self.genderLabel.text = "Gender: Female"
            r = 0.55
        } else {
            self.genderLabel.text = "Gender: Male"
            r = 0.68
        }
        updateGender.isHidden = true
        genderLabel.isHidden = false
        
        gender.isHidden = true
        saveGender.isHidden = true
    }
    @IBAction func updateWeight(_ sender: Any) {
        updateWeight.isHidden = true
        weightLabel.isHidden = true
        
        weightLabelUpdate.isHidden = false
        weightSlider.isHidden = false
        saveWeight.isHidden = false
    }
    @IBAction func saveWeight(_ sender: Any) {
        var currentUser = PFUser.current()
        if currentUser != nil {
            currentUser?["Weight"] = Int(self.weightSlider.value)

            currentUser?.saveInBackground()
        }
        
        let updatedWeight = Int(self.weightSlider.value)
        self.weightLabel.text = "Weight: \(String(describing: updatedWeight))"
        updateWeight.isHidden = true
        weightLabel.isHidden = false
        
        weightLabelUpdate.isHidden = true
        weightSlider.isHidden = true
        saveWeight.isHidden = true
    }
    @IBAction func updateDrink(_ sender: Any) {
        updateDrink.isHidden = true
        saveDrink.isHidden = false
        favDrinkPicker.isHidden = false
    }
    @IBAction func saveDrink(_ sender: Any) {
        var currentUser = PFUser.current()
        if currentUser != nil {
            currentUser?["FavDrink"] = self.favDrink

            currentUser?.saveInBackground()
        }
        updateDrink.isHidden = true
        saveDrink.isHidden = true
        favDrinkPicker.isHidden = true
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
