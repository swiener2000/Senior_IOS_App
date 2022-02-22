//
//  ProfileViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 2/21/22.
//

import UIKit
import Parse
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var favDrinkLabel: UILabel!
    
    var r: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
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
