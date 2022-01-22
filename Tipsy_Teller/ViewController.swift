//
//  ViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 1/21/22.
//

import UIKit
import Parse

class ViewController: UIViewController {


    @IBOutlet weak var txtUsernameSignin: UITextField!
    @IBOutlet weak var txtPasswordSignin: UITextField!
    @IBOutlet weak var indicatorLogin: UIActivityIndicatorView!
    
    @IBOutlet weak var GenderSignup: UISegmentedControl!
    @IBOutlet weak var WeightSignup: UISlider!
    @IBOutlet weak var txtLastNameSignup: UITextField!
    @IBOutlet weak var txtFirstNameSignup: UITextField!
    @IBOutlet weak var txtUsernameSignup: UITextField!
    @IBOutlet weak var txtPasswordSignup: UITextField!
    @IBOutlet weak var indicatorSignup: UIActivityIndicatorView!
    
    @IBOutlet weak var WeightLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        testParseConnection()
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
                
        WeightLabel.text = "Weight: \(currentValue) lbs"
    }
    @IBAction func signin(_ sender: Any) {
            PFUser.logInWithUsername(inBackground: self.txtUsernameSignin.text!, password: self.txtPasswordSignin.text!) {
              (user: PFUser?, error: Error?) -> Void in
              if user != nil {
                  print("login successful")
              } else {
                print("login unsuccessful")
              }
            }
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
                } else {
                    print("Account has been successfully created")
                }
            }
        }
    func testParseConnection() {
        let myObj = PFObject(className:"FirstClass")
                myObj["message"] = "Hey ! First message from Swift. Parse is now connected"
                myObj.saveInBackground { (success, error) in
                    if(success){
                        print("You are connected!")
                    }else{
                        print("An error has occurred!")
                    }
                }
    }

}



