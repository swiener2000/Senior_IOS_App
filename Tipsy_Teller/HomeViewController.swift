//
//  HomeViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 1/29/22.
//

import UIKit
import Parse

class HomeViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var favDrinkLabel: UILabel!
    
    var r: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        testParseConnection()
        // Do any additional setup after loading the view.
        if let pUserName = PFUser.current()?["username"] as? String {
            self.userNameLabel.text = "@" + pUserName
            let firstname = PFUser.current()?["First_Name"] as? String
            let lastname = PFUser.current()?["Last_Name"] as? String
            let gender = PFUser.current()?["Gender"] as? Int
            let weight = PFUser.current()?["Weight"] as? Double
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
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if (PFUser.current() == nil) {
            DispatchQueue.global(qos: .background).async {

                // Background Thread

                DispatchQueue.main.async {
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func logOutAction(sender: AnyObject){
        
        // Send a request to log out a user
        PFUser.logOut()
        DispatchQueue.global(qos: .background).async {

            // Background Thread

            DispatchQueue.main.async {
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
