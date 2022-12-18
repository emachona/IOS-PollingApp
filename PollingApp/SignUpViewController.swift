//
//  SignUpViewController.swift
//  PollingApp
//
//  Created by Emilija Chona on 12/14/22.
//

import UIKit
import FirebaseAuth
//import Firebase

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var avSwitch: UISwitch!
    @IBOutlet weak var voterLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signupPressed(_ sender: Any) {
        if emailTF.text?.isEmpty == true {
            print("Email field can't be empty!")
            //displayAlert(title: "Missing Information", message: "You must provide email!")
            return
        }
        
        if passwordTF.text?.isEmpty == true {
            print("Password field can't be empty!")
            //displayAlert(title: "Missing Information", message: "You must provide password!")
            return
        }
        
        signUp()
    }
    
    func signUp(){
        Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!){
            (user, error) in  if error != nil{
                print("Error \(error?.localizedDescription)")
                //self.displayAlert(title: "Error", message: error!.localizedDescription)
                return
            }
            else{
                print("Sign Up Success!")
                if self.avSwitch.isOn {
                    //Administrator
                    let req = Auth.auth().currentUser?.createProfileChangeRequest();
                    req?.displayName = "Administrator"
                    req?.commitChanges(completion: nil)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier:"Login")
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                    //self.performSegue(withIdentifier: "adminSegue", sender: nil)
                }
                else {
                    //Voter
                    let req = Auth.auth().currentUser?.createProfileChangeRequest();
                    req?.displayName = "Voter"
                    req?.commitChanges(completion: nil)
                    self.performSegue(withIdentifier: "voterSegue", sender: nil)
                }
            }
        }
    }
}
