//
//  SignUpViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 1/29/22.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var GenderSignup: UISegmentedControl!
    @IBOutlet weak var WeightSignup: UISlider!
    @IBOutlet weak var txtLastNameSignup: UITextField!
    @IBOutlet weak var txtFirstNameSignup: UITextField!
    @IBOutlet weak var txtUsernameSignup: UITextField!
    @IBOutlet weak var txtPasswordSignup: UITextField!
    @IBOutlet weak var favDrinkSignup: UIPickerView!
    
    @IBOutlet weak var WeightLabel: UILabel!
    var cocktails = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        queryDrinks()
        self.favDrinkSignup.delegate = self
        self.favDrinkSignup.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
                
        WeightLabel.text = "Weight: \(currentValue) lbs"
    }
    
    @IBAction func signup(_ sender: Any) {
        let user = PFUser()
        user.username = self.txtUsernameSignup.text
        user.password = self.txtPasswordSignup.text
        user["First_Name"] = self.txtFirstNameSignup.text
        user["Last_Name"] = self.txtLastNameSignup.text
        user["Gender"] = self.GenderSignup.selectedSegmentIndex
        user["Weight"] = Int(self.WeightSignup.value)
            
            user.signUpInBackground {(succeeded: Bool, error: Error?) -> Void in
                if let error = error {
                    print("sign up unsuccessful")
                    let alert = UIAlertController(title: "Unable to sign up", message: "Seems like you are missing a couple fields, please go back and fill out all fields to create your account", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (_) in
                                
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                } else {
                    print("Account has been successfully created")
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true)
                }
            }
        }
    func queryDrinks() {
        let query = PFQuery(className:"Cocktails")
        query.selectKeys(["Name"])
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
          if let error = error {
            // The request failed
            print(error.localizedDescription)
          } else {
              let objects = results!
              for object in objects {
                  let someString = object.value(forKey: "Name") as! String
                  self.cocktails.append(someString)
              }
              

              for name in self.cocktails {
                  print("\(name)")
              }
          }
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cocktails.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cocktails[row]
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
