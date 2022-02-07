//
//  LoginViewController.swift
//  Tipsy_Teller
//
//  Created by Stephanie Wiener on 1/29/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUsernameSignIn: UITextField!
    @IBOutlet weak var txtPasswordSignIn: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
    }
    @IBAction func signin(_ sender: Any) {
            PFUser.logInWithUsername(inBackground: self.txtUsernameSignIn.text!, password: self.txtPasswordSignIn.text!) {
              (user: PFUser?, error: Error?) -> Void in
              if user != nil {
                  print("login successful")
                  let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
                  viewController.modalPresentationStyle = .fullScreen
                  self.present(viewController, animated: true)
              } else {
                print("login unsuccessful")
                  let alert = UIAlertController(title: "Username or Password Incorrect", message: "Username and password combination does not exist, please try again", preferredStyle: .alert)
                          
                          alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (_) in
                              
                          }))
                          
                          self.present(alert, animated: true, completion: nil)
              }
            }
        }
    @IBAction func signUp(_ sender: Any) {

        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
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
