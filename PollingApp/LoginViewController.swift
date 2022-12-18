//
//  LoginViewController.swift
//  PollingApp
//
//  Created by Emilija Chona on 12/14/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTV: UITextField!
    @IBOutlet weak var passwordTV: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupLinkBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser {
            print(Auth.auth().currentUser?.uid)
            if user.displayName == "Administrator" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier:"adminView")
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true)
                //self.performSegue(withIdentifier: "adminSegue", sender: nil)
            }
            else {
                //self.performSegue(withIdentifier: "voterSegue", sender: nil)
            }
        }
    }

    @IBAction func loginPressed(_ sender: Any) {
        validateFields()
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier:"SignUp")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func validateFields(){
        if emailTV.text?.isEmpty == true {
            print("Email field is required!")
            return
        }
        
        if passwordTV.text?.isEmpty == true {
            print("Password field is required!")
            return
        }
        
        login()
    }
    
    func login(){
        Auth.auth().signIn(withEmail: emailTV.text!, password: passwordTV.text!) { (user, error) in
            if error != nil {
                print("Error logging in")
                //displayAlert(title: "Error", message: error!.localizedDescription)
            }
            else {
                print("Log In Success")
                if user?.user.displayName == "Voter" {
                    print("Voter")
                    self.performSegue(withIdentifier: "voterSegue", sender: nil)
                }
                else {
                    print("Administrator")
                    print(Auth.auth().currentUser?.uid)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier:"adminView")
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                    //self.performSegue(withIdentifier: "adminSegue", sender: nil)
                }
            }
        }
    }
}
